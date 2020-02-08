function [D, taglist] = load_data(config, type)
    rootPath = config.general.rootPath;
    trainDataSize = config.train.dataSize;
    testDataSize = config.test.dataSize;

    if strcmp('train', type)
        data_path = strcat(rootPath, 'data/formative_pascal/train.mat');
        load(data_path);

        D = [];
        row_D = [D1 D2];
        
        % Filter samples which has only one object
        for n = 1:size(row_D,2)
            if(length(find(row_D(n).objectcount == 0))==19)
                D = [D row_D(n)];
            end
        end
        
        D = D(1, 1:trainDataSize);
        taglist = {};
        for n=1:trainDataSize
            taglist{n} = D(1, n).taglist;
        end

    else % otherwise, load test data set
        data_path = strcat(rootPath, 'data/formative_pascal/test.mat');
        load(data_path);

        D = [];
        row_D = [D1 D2];
        
        % Filter samples which has only one object
        for n = 1:size(row_D,2)
            if(length(find(row_D(n).objectcount == 0))==19) % Only one object
                D = [D row_D(n)];
            end
        end
        
        D = D(1, 1:testDataSize);
        taglist = {};
        for n=1:testDataSize
            taglist{n} = D(1, n).taglist;
        end
    end
end