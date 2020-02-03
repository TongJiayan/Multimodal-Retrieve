
function [config] = initialize
    addpath ./extract_features
    addpath ./util
    
    % load configurations
    config = load_config();
    disp('config.xml has been loaded.');
end