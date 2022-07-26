function [outputPath, Fs] = modifyPitch(filename, freqScalingParam, timeScalingParam)
%     clear classes; close all; clc;
%     x = py.importlib.import_module('harmonicTransformations_function');
%     py.reload(x);
    anal = py.harmonicTransformations_function.analysis(filename, 'blackman', 1201, 2048, -90, 0.1, 150, 100, 300, 7, 0.01);
    inputFile = anal{1};
    fs = anal{2};
    hfreq = anal{3};
    hmag = anal{4};

%     freqScaling = py.numpy.array([0, 1, 0.9, 1, 1, 0.95, 5, 0.95, 5.1, 1]);
    disp(freqScalingParam);
    disp(timeScalingParam);
    freqScaling = py.numpy.array(freqScalingParam);
    freqStretching = py.numpy.array([0,1,1,1]);
    % timeScaling = py.numpy.array([0,0,1,1]);
    timeScaling = py.numpy.array(timeScalingParam);
    py.harmonicTransformations_function.transformation_synthesis(inputFile,fs,hfreq,hmag,freqScaling,freqStretching,1,timeScaling);
    outputPath = ['../outputSounds/' filename '_harmonicModelTransformation.wav'];
    Fs = fs;
end
