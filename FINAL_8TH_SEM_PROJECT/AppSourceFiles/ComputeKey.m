%> @brief computes the key of the input audio (super simple variant)
%>
%> @param afAudioData: time domain sample data, dimension samples X channels
%> @param f_s: sample rate of audio data
%> @param afWindow: FFT window of length iBlockLength (default: hann), can be [] empty
%> @param iBlockLength: internal block length (default: 4096 samples)
%> @param iHopLength: internal hop length (default: 2048 samples)
%>
%> @retval cKey key string
% ======================================================================
function [cKey] = ComputeKey (afAudioData, f_s, afWindow, iBlockLength, iHopLength)

    % set default parameters if necessary
    if (nargin < 5)
        iHopLength      = 2048;
    end
    if (nargin < 4)
        iBlockLength    = 4096;
    end

    if (nargin < 3 || isempty(afWindow))
        afWindow    = hann(iBlockLength,'periodic');
    end

    % key names
    cMajor  = char ('C Maj','C# Maj','D Maj','D# Maj','E Maj','F Maj',...
        'F# Maj','G Maj','G# Maj','A Maj','A# Maj','B Maj');
    cMinor  = char ('c min','c# min','d min','d# min','e min','f min',...
        'f# min','g min','g# min','a min','a# min','b min');
    
    % template pitch chroma (Krumhansl major/minor)
    t_pc1    = [6.35 2.23 3.48 2.33 4.38 4.09 2.52 5.19 2.39 3.66 2.29 2.88
               6.33 2.68 3.52 5.38 2.60 3.53 2.54 4.75 3.98 2.69 3.34 3.17];
           
    t_pc    = diag(1./sum(t_pc1,2))*t_pc1;
    
    
    
    % compute FFT window function
    if (length(afWindow) ~= iBlockLength)
        error('window length mismatch');
    end        

    % pre-processing: down-mixing
    if (size(afAudioData,2)> 1)
        afAudioData = mean(afAudioData,2);
    end
    % pre-processing: normalization (not necessary for many features)
    afAudioData = afAudioData/max(abs(afAudioData));

    % in the real world, we would do this block by block...
    [X,f,t]     = spectrogram(  afAudioData,...
                                afWindow,...
                                iBlockLength-iHopLength,...
                                iBlockLength,...
                                f_s);
    
    % magnitude spectrum
    X  = abs(X)*2/iBlockLength;
%     figure(2)
%     plot(t,X)
%     spectrogram(afAudioData,'yaxis')
    % instantaneous pitch chroma
    v_pc        = FeatureSpectralPitchChroma(X, f_s);
%    disp(size(v_pc))
%     figure(1)
%     subplot 311
%     stem(t_pc1(1,:))
%     subplot 312
%     stem(t_pc1(2,:))
%     subplot 313
%     stem(v_pc(:,1))
%     disp(size(t_pc1))

    % average pitch chroma
    v_pc= mean(v_pc,2);
%     disp(size(v_pc))
%     new = repmat(v_pc',2,1)
%     disp(c)
%     disp(size(c))
    
    % compute manhattan distances for major and minor
    d = zeros(2,12);
    for (i = 0:11)
        d(:,i+1)    = sum(abs(repmat(v_pc',2,1)-circshift(t_pc,[0 i])),2);
%         disp(d)
    end
%     disp(repmat(v_pc',2,1))
%     disp(circshift(t_pc,[0 0]))
%     disp(v_pc')
%     disp(d)
%     disp()
%     disp(d)
    [dist,iKeyIdx]  = min(d,[],2);
%     disp([dist iKeyIdx])
    if (dist(1) < dist(2))
        cKey    = deblank(cMajor(iKeyIdx(1),:));
    else
        cKey    = deblank(cMinor(iKeyIdx(2),:));
    end    
end

% ======================================================================
% ======================================================================
%> @brief computes the pitch chroma from the magnitude spectrum
%> called by ::ComputeFeature
%>
%> @param X: spectrogram (dimension FFTLength X Observations)
%> @param f_s: sample rate of audio data
%>
%> @retval vpc pitch chroma
% ======================================================================
function [vpc] = FeatureSpectralPitchChroma(X, f_s)

    % allocate memory
    vpc = zeros(12, size(X,2));

    % generate filter matrix
    H  = GeneratePcFilters(size(X,1), f_s);
 
    % compute pitch chroma
    vpc = H * X.^2;
    
    % norm pitch chroma to a sum of 1
    vpc = vpc ./ repmat(sum(vpc,1), 12, 1);
       
    % avoid NaN for silence frames
    vpc (:,sum(X,1) == 0) = 0;
end

%> generate the semi-tone filters (simple averaging)
function [H] = GeneratePcFilters (iSpecLength, f_s)

    % initialization at C4
    f_mid           = 261.63;
    iNumOctaves     = 4;
    
    %sanity check
    while (f_mid*2^iNumOctaves > f_s/2 )
        iNumOctaves = iNumOctaves - 1;
    end
    
    H = zeros (12, iSpecLength);
    
    for (i = 1:12)
        afBounds  = [2^(-1/24) 2^(1/24)] * f_mid * 2* (iSpecLength-1)/f_s;
        for (j = 1:iNumOctaves)
           iBounds                      = [ceil(2^(j-1)*afBounds(1)) floor(2^(j-1)*afBounds(2))]+1;
           H(i,iBounds(1):iBounds(2))   = 1/(iBounds(2)+1-iBounds(1));
        end
        % increment to next semi-tone
        f_mid   = f_mid*2^(1/12);
    end   
end