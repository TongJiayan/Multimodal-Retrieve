function [config] = load_config()
    xmlfile = xmlread('config.xml');

    % general configuration
    general = xmlfile.getElementsByTagName('general').item(0);
    rootPath = general.getElementsByTagName('rootPath').item(0).getTextContent;
    algorithm = general.getElementsByTagName('algorithm').item(0).getTextContent;
    dataset = general.getElementsByTagName('dataset').item(0).getTextContent;
    direction = general.getElementsByTagName('direction').item(0).getTextContent;
    pca = general.getElementsByTagName('pca').item(0).getTextContent;
    image_feature = general.getElementsByTagName('image_feature').item(0).getTextContent;
    
    % config object creation
    config = {};
    config.general.rootPath = char(rootPath);
    config.general.algorithm = char(algorithm);
    config.general.dataset = char(dataset);
    config.general.direction = char(direction);
    config.general.pca = str2double(pca);
    config.general.image_feature = char(image_feature);
    
    if strcmp(config.general.dataset,'PASCAL')
        pascal = xmlfile.getElementsByTagName('pascal').item(0);
        numOfWords = pascal.getElementsByTagName('numOfWords').item(0).getTextContent;
        trainDataSize = pascal.getElementsByTagName('trainDataSize').item(0).getTextContent;
        testDataSize = pascal.getElementsByTagName('testDataSize').item(0).getTextContent;
  
        config.numOfWords = str2double(numOfWords);
        config.trainDataSize = str2double(trainDataSize);
        config.testDataSize = str2double(testDataSize);
    elseif strcmp(config.general.dataset,'WIKI')
        wiki = xmlfile.getElementsByTagName('wiki').item(0);
        trainDataSize = wiki.getElementsByTagName('trainDataSize').item(0).getTextContent;
        testDataSize = wiki.getElementsByTagName('testDataSize').item(0).getTextContent;
        
        config.trainDataSize = str2double(trainDataSize);
        config.testDataSize = str2double(testDataSize);  
    elseif strcmp(config.general.dataset,'NUSWIDE')
        nuswide = xmlfile.getElementsByTagName('nuswide').item(0);
        trainDataSize = nuswide.getElementsByTagName('trainDataSize').item(0).getTextContent;
        testDataSize = nuswide.getElementsByTagName('testDataSize').item(0).getTextContent;
        
        config.trainDataSize = str2double(trainDataSize);
        config.testDataSize = str2double(testDataSize); 
    end
end