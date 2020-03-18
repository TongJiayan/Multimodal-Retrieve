function [data] = load_wiki(config)
    rootPath = config.general.rootPath;
    
    dataPath = strcat(rootPath,'data\wiki\raw_features.mat');
    trainsetCatListPath = strcat(rootPath,'data\wiki\trainset_txt_img_cat.list');
    testsetCatListPath = strcat(rootPath,'data\wiki\testset_txt_img_cat.list');
        
    trainCatList = importdata(trainsetCatListPath);
    testCatList = importdata(testsetCatListPath);

    data = {};
    data.train = {};
    data.test = {};
    load(dataPath);
    data.train.image = I_tr;
    data.train.text = T_tr;
    data.train.cat_list = trainCatList.data;
    data.test.image = I_te;
    data.test.text = T_te;
    data.test.cat_list = testCatList.data;
end

