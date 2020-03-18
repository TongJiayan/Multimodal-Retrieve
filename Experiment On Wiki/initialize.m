function [config] = initialize
    addpath ./util
    addpath ./retrieve
    addpath ./common
    
    % load configurations
    config = load_config();
    disp('config.xml has been loaded.');
end

