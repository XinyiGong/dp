'''
Python functions to post-process data
from ABAQUS output database (odb).

Author (unless otherwise stated)
Marat I. Latypov
Georgia Tech Lorraine
marat.latypov@georgiatech-metz.fr
'''

from abaqus import *
from abaqusConstants import *
from odbAccess import *
import __main__

import numpy as np
import math
import sys
import timeit

def mequit(f):
	f.close()
	sys.exit('Script exited with an error')

def getScalarData(varName, myFrame, varField, myInstance, numElements):
	''' Read scalar data for requested time frame, instance and average over IPs.'''

	aveScalar = np.zeros((numElements))

	numIntPts = len(varField.getSubset(region=myInstance.elements[0]).values)
	scalarData = np.zeros((numIntPts))
	for el in range(0,numElements):
		# Isolate current and previous element's stress field
		abaVar = varField.getSubset(region=myInstance.elements[el]).values

		for ip,ipValue in enumerate(abaVar):
			scalarData[ip] = ipValue.data

		# Average the variable values for the element
		aveScalar[el] = np.average(scalarData,axis=0)

	return aveScalar

def getSymTensorData(varName, myFrame, myInstance, mySet, numElements):
	''' Read symmetric tensor data for requested time frame, instance, set and average over IPs.'''

	varField = myFrame.fieldOutputs[varName]
	field = varField.getSubset(region=mySet, position=CENTROID)

	numIntPts = len(varField.getSubset(region=myInstance.elements[0]).values)
	numComps = len(varField.getSubset(region=myInstance.elements[0]).values[0].data)
	tensorData = np.zeros((numIntPts,numComps))
	aveTensor = np.zeros((numElements,numComps))

	for el in range(0,numElements):
		# Isolate current and previous element's stress field
		abaVar = varField.getSubset(region=myInstance.elements[el]).values

		for ip,ipValue in enumerate(abaVar):
			for icomp,component in enumerate(ipValue.data):
				tensorData[ip,icomp] = ipValue.data[icomp]

		# Average the variable values for the element
		aveTensor[el,:] = np.average(tensorData,axis=0)
	return aveTensor

def getFullTensorData(tensorData):
	''' Recover full tensor (9 components) for a symmetric tensor (6 components).'''

	tensorFull = np.zeros((tensorData.shape[0],9))
	tensorFull[:,0] = tensorData[:,0]
	tensorFull[:,1] = tensorData[:,3]
	tensorFull[:,2] = tensorData[:,4]

	tensorFull[:,3] = tensorData[:,3]
	tensorFull[:,4] = tensorData[:,1]
	tensorFull[:,5] = tensorData[:,5]

	tensorFull[:,6] = tensorData[:,4]
	tensorFull[:,7] = tensorData[:,5]
	tensorFull[:,8] = tensorData[:,2]

	return tensorFull

def Mises(what,tensor):
	''' Calulate von Mises value for stress or strain tensor.
	Source: DAMASK (http://damask.mpie.de).'''

	# Get deviatoric tensor
	dev = tensor - np.trace(tensor)/3.0*np.eye(3)

	# Symmetrize
	symdev = 0.5*(dev+dev.T)

	# Get Mises value
	return math.sqrt(np.sum(symdev*symdev.T)*
      {
       'stress': 3.0/2.0,
       'strain': 2.0/3.0,
       }[what.lower()])

def getMises(what,tensArray):
	''' Average strain or stress components over elements and pass them for calculation of Mises values.'''

	tCompAve = np.zeros(9)
	# Loop over components and find their spatial averages
	for iComp in range(9):
		tCompAve[iComp] = np.average(tensArray[:,iComp])

	# Call function for calculation of Mises values
	eq = Mises(what,np.reshape(tCompAve,(3,3)))
	return eq

def odb2ss(fileName,f,phSets,instanceName=None,mySetName=None):
	''' Read stress, strain tensors from the odb for
		all available time frames, average the components over
		all elements and get equivalent stress and strain.'''

	# Open the odb
	try:
		odbPath = fileName + '.odb'
		myOdb = session.openOdb(name=odbPath)
	except OdbError:
		msg = 'ERROR! Failed to open odb at %s\n' % odbPath
		f.write(msg)
		mequit(f)

	msg = 'odb was successfully opened at %s\n' % odbPath
	f.write(msg)

	# The first instance is default if not provided
	if instanceName == None:
		instanceName = myOdb.rootAssembly.instances.keys()[0]

	# 'AllElements' set is default if not provided
	if mySetName == None:
		mySetName = 'ALLELEMENTS'

	# Name the Step object for convenience
	myStepName = myOdb.steps.keys()[0]
	myStep = myOdb.steps[myStepName]
	msg = 'Working with step %s and instance %s\n' % (myStepName, instanceName)
	f.write(msg)

	# Check if the instance exists
	instanceNames = myOdb.rootAssembly.instances.keys()
	if instanceName not in instanceNames:
		instanceList = '\n'.join(iInstance for iInstance in instanceNames)
		msg = '\nERROR!\nInstance %s was not found! Available instances in the odb:\n%s'  % (instanceName, instanceList)
		f.write(msg)
		mequit(f)
	else:
		# Get Instance object
		myInstance = myOdb.rootAssembly.instances[instanceName]

	# Check if the set exists
	setNames = myOdb.rootAssembly.instances[instanceName].elementSets.keys()
	if mySetName not in setNames:
		setList = str(setNames)
		msg = '\nERROR!\nElement set %s was not found! Available sets in the odb:\n%s'  % (mySetName, setList)
		f.write(msg)
		mequit(f)
	else:
		# Get Set object
		mySet = myInstance.elementSets[mySetName]

	# Get total number of elements, nodes, time frames
	numElements = len(myInstance.elements)
	numNodes = len(myInstance.nodes)
	numFrames = len(myStep.frames)

	f.write('Number of frames: %s\n' % str(numFrames))

	# Get feature IDs
	if phSets:
		ph = np.zeros((numElements))
		for i,iSet in enumerate(phSets):
			for iel in myInstance.elementSets[iSet].elements:
				ph[iel.label-1] = i+1
	else:
		ph = None

	# Get object for the last time frame
	myFrame = myStep.frames[-1]
	f.write('Working for time frame: %7.4f\n' % myFrame.frameValue)

	# Get stress tensor for current frame
	varName = 'S'
	tensor = getSymTensorData(varName, myFrame, myInstance, mySet, numElements)
	s = getFullTensorData(tensor)

	# Get equivalent stress
	eqStress = getMises('stress',s)

	# Get strain rate tensor for current frame
	varName = 'ER'
	tensor = getSymTensorData(varName, myFrame, myInstance, mySet, numElements)
	rate = getFullTensorData(tensor)

	# Get equivalent strain rate
	eqRate = getMises('strain',rate)


	# Get equivalent strain rate per feature
	if ph != None:
		numPh = len(np.unique(ph))
		eqRatePh = np.zeros((numPh))
		for iph in range(numPh):
			ind = ph == iph+1
			eqRatePh[iph] = getMises('strain',rate[ind,:])
	else:
		eqRatePh = None

	# Get strain
	varName = 'LE'
	tensor = getSymTensorData(varName, myFrame, myInstance, mySet, numElements)
	strain = getFullTensorData(tensor)

	# Get equivalent strain
	eqStrain = getMises('strain',strain)

	return eqStress, eqStrain, eqRate, eqRatePh, ph

import timeit
import glob

# Set names containing features
phSets = ['PHASE_1','PHASE_2']

ind = '02'

# Find odb files
files2search = '%s_*.odb' % ind
odbFiles = glob.glob(files2search)
odbFiles.sort()

# Open file for status messages
staFileName = 'yyy_aba2sp_%s.out' % ind
stafile = open(staFileName,'w')

# Start a loop over odb files
for i,f in enumerate(odbFiles):

	# Get file name without extension
	fname = os.path.splitext(f)[0]

	tic = timeit.default_timer()

	# Get equivalent stress, strain from odb
	eqStress, eqStrain, eqRate, eqRatePh, ph = odb2ss(fname,stafile,phSets)

	toc = timeit.default_timer()
	msg = 'Done with %s, spent %.2f min\n\n' % (f, (toc-tic)/60.0)
	stafile.write(msg)

	# Save results to npy
	np.save('stress_' + fname,eqStress)
	np.save('strain_' + fname,eqStrain)
	np.save('rate_' + fname,eqRate)
	if phSets:
		np.save('ph_' + fname,ph)
		for i in range(len(np.unique(ph))):
			istr = 'rate_ph-%d_%s' % (i+1,fname)
			np.save(istr,eqRatePh[i])

stafile.close()
