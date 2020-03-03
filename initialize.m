
function [config] = initialize
    addpath ./extract_features
    addpath ./util
    addpath ./CCA
    addpath ./PLS
    addpath ./BLM
    
    % load configurations
    config = load_config();
    disp('config.xml has been loaded.');
end