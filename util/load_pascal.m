function [data] = load_pascal(config)
    rootPath = config.general.rootPath;
    trainDataPath = strcat(rootPath,'data\pascal\train.mat');
    testDataPath = strcat(rootPath,'data\pascal\test.mat');
    
    [train_raw_data,train_taglist,~] = load_raw_data(trainDataPath,config.trainDataSize);
    [test_raw_data,test_taglist,objectcount] = load_raw_data(testDataPath,config.testDataSize);
    train_features = extract_features(train_raw_data,train_taglist,config,'train');
    test_features = extract_features(test_raw_data,test_taglist,config,'test');
        
    data = {};
    data.train = {};
    data.test = {};
    data.test.objectcount = objectcount;  
    data.train.text = pre_process(train_features.wc);
    data.train.image = pre_process(double(train_features.gist));
    data.test.text = pre_process(test_features.wc);
    data.test.image = pre_process(double(test_features.gist));  
end

function [raw_data,taglist,objectcount] = load_raw_data(dataPath,dataSize)
    load(dataPath);
    D = [D1 D2];
    raw_data = [];
    
    % Filter samples which has only one object
    for n = 1:size(D,2)
        if(length(find(D(n).objectcount == 0))==19)
            raw_data = [raw_data D(n)];
        end
    end  

    taglist = {};
    objectcount = [];
    for n=1:dataSize
        taglist{n} = raw_data(1, n).taglist;
        objectcount = [objectcount;raw_data(1,n).objectcount];
    end 
end

function [F] = extract_features(D, taglist, config,type)  
    numOfWords = config.numOfWords;
    if strcmp(type, 'train')
        dataSize = config.trainDataSize;
    elseif strcmp(type, 'test')
        dataSize = config.testDataSize;
    end
    
    F = {};
    
    if ~isempty(taglist)
        F.wc = extract_tag_feature(taglist, 'wordcount', dataSize, numOfWords);
        F.rel = extract_tag_feature(taglist, 'relrank', dataSize, numOfWords);
        F.abs = extract_tag_feature(taglist, 'absrank', dataSize, numOfWords);
    end
    
    F.gist = extract_visual_feature('gist',dataSize,D);
    F.hsv = extract_visual_feature('hsv',dataSize,D);
    F.bow = extract_visual_feature('bow',dataSize,D);
end

function [feature] = extract_visual_feature(type, dataSize, D)

    feature = [];
    if strcmp(type,"gist")
        for n=1:dataSize
          feature = [feature; D(1, n).gist];
        end
    elseif strcmp(type,"hsv")
        for n=1:dataSize
          feature = [feature; D(1, n).color];
      end
   elseif strcmp(type,"bow")
        for n=1:dataSize
          feature = [feature; D(1, n).bow];
        end  
    end
end

function [feature] = extract_tag_feature(taglist, type, dataSize, numOfWords)

    if strcmp(type, 'wordcount')
        feature = extract_wordcount(taglist, dataSize, numOfWords);  
    elseif strcmp(type, 'relrank')
        feature = extract_relative_rank(taglist, dataSize, numOfWords);   
    elseif strcmp(type, 'absrank')
        feature = extract_absolute_rank(taglist, dataSize, numOfWords);
    else
        disp('type must be one of (wordcount/relrank/absrank).');
        feature = [];
    end
end

function [wordcount] = extract_wordcount(taglist, dataSize, numOfWords)
    
    wordcount = zeros(dataSize, numOfWords);
    for n=1:dataSize
        if size(taglist{n}, 1) == 0
            continue;
        end

        indices = unique(taglist{n});
        if numel(indices) == 1
            wordcount(n, indices) = numel(taglist{n});
        else
            wordcount(n, indices) = hist(taglist{n}, indices);
        end
    end
end

function [relRank] = extract_relative_rank(taglist, dataSize, numOfWords)  

    N = 50;
    taglistBound = 2*N; % This is arbitrary value.
    relRankRef = zeros(numOfWords, taglistBound);

    for n=1:dataSize
        if size(taglist{n}, 1) == 0
            continue;
        end

        taglistSize = min(size(taglist{n}, 2), taglistBound);
        for m=1:taglistSize
            rank = m;
            word = taglist{n}(m);
            relRankRef(word, rank) = relRankRef(word, rank) + 1; 
        end
    end

    sumRelRankRef = sum(relRankRef, 2);
    sumRelRankRef(sumRelRankRef == 0) = Inf;
    relRankRef = relRankRef ./ repmat(sumRelRankRef, 1, taglistBound);

    % add previous values - generate cumulative histogram
    for n=2:taglistBound
        relRankRef(:, n) = relRankRef(:, n-1) + relRankRef(:, n);
    end

    relRank = zeros(dataSize, numOfWords);
    for n=1:dataSize
        if size(taglist{n}, 1) == 0
            continue;
        end

        % calculate average absolute rank in the given image taglist.
        avgAbsRank = [];
        uniq = unique(taglist{n});
        for m=1:size(uniq, 2)
            ranks = find(taglist{n} == uniq(m));
            avgAbsRank(m) = sum(ranks)/size(ranks, 2);
            relRank(n, uniq(m)) = 1- (relRankRef(uniq(m), min(round(avgAbsRank(m)), N)) / relRankRef(uniq(m), N));
        end
    end
end

function [absRank] = extract_absolute_rank(taglist, dataSize, numOfWords)
   
    absRank = zeros(dataSize, numOfWords);
    for n=1:dataSize
        if size(taglist{n}, 1) == 0
            continue;
        end

        tags = taglist{n};
        for m=numel(tags):-1:1 % substitute each rank with the first appearance of the word in the tag-list
            absRank(n, tags(m)) = m;
        end
    end

    absRank = log2(1+absRank);
    absRank(find(absRank == 0)) = Inf;
    absRank = 1./absRank;
end

function[processed_data] = pre_process(raw_data)
    dataSize = size(raw_data,1);
    % Decentralization
    processed_data = raw_data - repmat(mean(raw_data),dataSize,1);
    % Normalize
    processed_data = processed_data * sqrt(diag(1./diag(processed_data'*processed_data)));
    processed_data(isnan(processed_data)==1)=0;
end





