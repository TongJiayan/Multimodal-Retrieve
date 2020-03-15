function [config] = initialize
    addpath ./util
    addpath ./retrieve
    
    % load configurations
    config = load_config();
    disp('config.xml has been loaded.');
end

