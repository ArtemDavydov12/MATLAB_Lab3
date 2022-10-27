%% filters design
freqArray = [31, 62, 125, 250, 500, 1000, 2000, 4000, 8000, 16000];
order = 1024;
fS = 44100;
f_bank = CreateFilters(freqArray, order, fS);
%% filtering of signals
[signal, fs] = audioread('song.mp3');
gain = ones (length(freqArray), 1);
initB = (1: order);
tic; signalOut_1 = filteringBanks(signal, f_bank, gain, 'filter', initB);toc;
tic; signalOut_2 = filteringBanks(signal, f_bank, gain, 'fftfilter');toc;
tic; signalOut_3 = filteringBanks(signal, f_bank, gain, 'convFilter');toc;
%% stream sound
deviceWriter = audioDeviceWriter('SampleRate', fS);
fileReader = dsp.AudioFileReader('song.mp3');
%gain = [10 10 10 0.1*ones(1, 7)]';
while ~isDone(fileReader)
    gain = rand(size(freqArray))';
    audioData = fileReader();
    [signalOut_4, initB] = filteringBanks(signal, f_bank, gain, 'filter', initB);
    deviceWriter(audioData);
end