#!/bin/bash
source /cvmfs/cms.cern.ch/cmsset_default.sh
export SCRAM_ARCH=slc6_amd64_gcc481
if [ -r CMSSW_7_1_20_patch2/src ] ; then 
 echo release CMSSW_7_1_20_patch2 already exists
else
scram p CMSSW CMSSW_7_1_20_patch2
fi
cd CMSSW_7_1_20_patch2/src
eval `scram runtime -sh`
curl  -s https://raw.githubusercontent.com/cms-sw/genproductions/master/python/ThirteenTeV/Higgs/HH/ResonanceDecayFilter_example_HHTo2B2T_madgraph_pythia8_cff.py --retry 2 --create-dirs -o  Configuration/GenProduction/python/ThirteenTeV/Higgs/HH/ResonanceDecayFilter_example_HHTo2B2T_madgraph_pythia8_cff.py 
[ -s Configuration/GenProduction/python/ThirteenTeV/Higgs/HH/ResonanceDecayFilter_example_HHTo2B2T_madgraph_pythia8_cff.py ] || exit $?;

export X509_USER_PROXY=$HOME/private/personal/voms_proxy.cert

scram b
cd ../../
cmsDriver.py Configuration/GenProduction/python/ThirteenTeV/Higgs/HH/ResonanceDecayFilter_example_HHTo2B2T_madgraph_pythia8_cff.py --filein "dbs:/GluGluToHHTo2B2Tau_node_SM_13TeV-madgraph/RunIIWinter15wmLHE-MCRUN2_71_V1-v1/LHE" --fileout file:HIG-RunIISummer15GS-00977.root --mc --eventcontent RAWSIM --customise SLHCUpgradeSimulations/Configuration/postLS1Customs.customisePostLS1,Configuration/DataProcessing/Utils.addMonitoring --datatier GEN-SIM --conditions MCRUN2_71_V1::All --beamspot Realistic50ns13TeVCollision --step GEN,SIM --magField 38T_PostLS1 --python_filename HIG-RunIISummer15GS-00977_1_cfg.py --no_exec -n 36 || exit $? ; 



echo "nothing" ;cmsDriver.py Configuration/GenProduction/python/ThirteenTeV/Higgs/HH/ResonanceDecayFilter_example_HHTo2B2T_madgraph_pythia8_cff.py --filein "dbs:/GluGluToHHTo2B2Tau_node_SM_13TeV-madgraph/RunIIWinter15wmLHE-MCRUN2_71_V1-v1/LHE" --fileout file:HIG-RunIISummer15GS-00977.root --mc --eventcontent DQM --datatier DQM --conditions MCRUN2_71_V1::All --beamspot Realistic50ns13TeVCollision --step GEN,VALIDATION:genvalid_all --magField 38T_PostLS1  --fileout file:HIG-RunIISummer15GS-00977_genvalid.root --mc -n 1000 --python_filename HIG-RunIISummer15GS-00977_genvalid.py  --no_exec || exit $? ;

cmsDriver.py step2 --filein file:HIG-RunIISummer15GS-00977_genvalid.root --conditions MCRUN2_71_V1::All --mc -s HARVESTING:genHarvesting --harvesting AtJobEnd --python_filename HIG-RunIISummer15GS-00977_genvalid_harvesting.py --no_exec || exit $? ; 