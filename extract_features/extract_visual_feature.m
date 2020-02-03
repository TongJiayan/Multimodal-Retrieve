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