clear all;
clc;
close all;

TSA_A02 = importdata('TSA_A02_60.mat');
TSA_A02 = TSA_A02(1:length(TSA_A02));
TSA_A02 = reshape(TSA_A02, length(TSA_A02), 1);

sample_size = 136;
data_size = 1051;
RMS_byfile = zeros(sample_size, 1);

for i = 1:sample_size
    
    if (i ~= sample_size)
        RMS_byfile(i) = myRMS( TSA_A02( (i-1)*data_size+1:i*data_size));
    else
        RMS_byfile(i) = myRMS( TSA_A02( (i-1)*data_size+1:end));        
    end

end

test_len = 40;
mean_test = mean(RMS_byfile(1:test_len));
RMS_meansub = RMS_byfile - mean_test;

lag_lim = 20;
AIC_val = zeros(1,lag_lim);

for lag = 1:lag_lim;
    
    arpoly = ar(RMS_meansub(1:test_len), lag);
    % [b, arpoly] = ARmod(RMS_meansub, lag, 40);
     AIC_val(lag) = aic(arpoly); 
    
end

[0.7804 0.9569 0.3922];
figure('name', 'AIc values', 'units',...
                'normalized','position',[.5 .47 .43 .43], 'color', 'w')
aic_bar = bar(1:length(AIC_val), AIC_val);

set(get(aic_bar,'BaseLine'),'LineWidth',2,'LineStyle',':')
colormap summer



title('AIC Values');
ylabel('AIC Value'); 
xlabel('Lag Order');

min_lag = find(AIC_val == min(AIC_val));

%Plotting AR
ARmod(RMS_meansub, min_lag, test_len);
% ARmod(RMS_meansub, 15, 40);

