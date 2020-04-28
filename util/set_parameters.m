function [factor, lamda] = set_parameters(config)
    dataset = config.general.dataset;
    algo = config.general.algorithm;
    with_PCA = config.general.pca;
    image_feature = config.general.image_feature;
    if strcmp(dataset,'PASCAL')
        switch algo
            case 'CCA'
                if with_PCA
                    factor = 6;
                    lamda = 1;
                else
                    factor =13; %13
                    lamda = 1;%1
                end
            case 'PLS'
                if with_PCA
                    factor = 11;
                    lamda = 1;
                else
                    factor = 63;
                    lamda = 1;
                end
            case 'BLM'
                if with_PCA
                    factor = 9;
                    lamda = 150;
                else
                    factor = 61;
                    lamda = 200;
                end
            case 'GMMFA'
                if with_PCA
                    factor = 9;
                    lamda = 1;
                else
                    factor = 57;
                    lamda = 10;
                end
        end
    elseif strcmp(dataset,'WIKI')
        switch algo
            case 'CCA'
                if with_PCA
                    factor = 5;
                    lamda = 1;
                elseif strcmp(image_feature,'VGG19')
                    factor = 7;
                    lamda = 1;
                else
                    factor = 13;
                    lamda = 1;
                end
            case 'PLS'
                if with_PCA
                    factor = 8;
                    lamda = 1;
                elseif strcmp(image_feature,'VGG19')
                    factor = 5;
                    lamda = 1;
                else
                    factor = 14;
                    lamda = 1;
                end
            case 'BLM'
                if with_PCA
                    factor = 26;
                    lamda = 3;
                elseif strcmp(image_feature,'VGG19')
                    factor = 32;
                    lamda = 1;
                else
                    factor = 13;
                    lamda = 2;
                end
            case 'GMMFA'
                if with_PCA
                    factor = 6;
                    lamda = 1;
                elseif strcmp(image_feature,'VGG19')
                    factor = 5;
                    lamda = 1;
                else
                    factor = 6;
                    lamda = 1;
                end
        end
    elseif strcmp(dataset,'NUSWIDE')
        switch algo
            case 'CCA'
                if with_PCA
                    factor = 2;%2
                    lamda = 1;
                elseif strcmp(image_feature,'VGG19')
                    factor = 3;
                    lamda = 1;
                else
                    factor = 2;
                    lamda = 1;
                end
            case 'PLS'
                if with_PCA
                    factor = 38;
                    lamda = 1;
                elseif strcmp(image_feature,'VGG19')
                    factor = 20;
                    lamda = 1;
                else
                    factor = 53;
                    lamda = 1;
                end
            case 'BLM'
                if with_PCA
                    factor = 15;
                    lamda = 3;
                elseif strcmp(image_feature,'VGG19')
                    factor = 14;
                    lamda = 1;
                else
                    factor = 13;
                    lamda = 2;
                end
            case 'GMMFA'
                if with_PCA
                    factor = 12;
                    lamda = 1;
                elseif strcmp(image_feature,'VGG19')
                    factor = 5;
                    lamda = 1;
                else
                    factor = 25;
                    lamda = 1;
                end
        end           
    else
        disp('The dataset should be WIKI or PASCAL.');
    end
end

