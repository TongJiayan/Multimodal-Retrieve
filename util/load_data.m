function [D, taglist,theNumberOfEachObject] = load_data(config, type)
    rootPath = config.general.rootPath;
    if strcmp('train', type)
        dataPath = strcat(rootPath, 'data/formative_pascal/train.mat');
        dataSize = config.train.dataSize;
    else
        dataPath = strcat(rootPath, 'data/formative_pascal/test.mat');
        dataSize = config.test.dataSize;
    end
    load(dataPath);
    
    rowData = [D1 D2];
    D = [];
    % Filter samples which has only one object
    for n = 1:size(rowData,2)
        if(length(find(rowData(n).objectcount == 0))==19)
            D = [D rowData(n)];
        end
    end    
    D = D(1, 1:dataSize);
    
    taglist = {};
    for n=1:dataSize
        taglist{n} = D(1, n).taglist;
    end

    theNumberOfEachObject = zeros([1,20]);
    if strcmp(type,'test')
        objectcount = zeros(dataSize,20);
        for n=1:dataSize
            objectcount(n,:)=D(1,n).objectcount;
        end
        for n=1:20
            theNumberOfEachObject(n) = length(find(objectcount(:,n)~=0));
        end
    end
end