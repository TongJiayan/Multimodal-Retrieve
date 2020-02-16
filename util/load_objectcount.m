function [theNumberOfEachObject] = load_objectcount(TD,config)
    testDataSize = config.test.dataSize;
    objectcount = zeros(testDataSize,20);
    for n=1:testDataSize
        objectcount(n,:)=TD(1,n).objectcount;
    end
    theNumberOfEachObject = zeros([1,20]);
    for n=1:20
        theNumberOfEachObject(n) = length(find(objectcount(:,n)~=0));
    end
end

