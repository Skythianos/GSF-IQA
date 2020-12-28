function [Train, Test] = splitTrainTest_CSIQ(names)
    
    numberOfImages = size(names,1);
   
    Train = false(numberOfImages,1);
    Test  = false(numberOfImages,1);
    
    p = randperm(30);
    
    train = p(1:round(30*0.80));
    test  = p(round(30*0.80)+1:end);
    
    prefix = cell(numberOfImages,1);
    
    for i=1:numberOfImages
        parts = strsplit(names{i}, '.');
        prefix{i,1} = parts{1,1};
    end

    prefixUnique = unique(prefix);
    
    selectedForTrain = prefixUnique(train);
    selectedForTest  = prefixUnique(test);
    
    for i=1:numberOfImages
        parts = strsplit(names{i}, '.');
        if( ismember(parts{1,1}, selectedForTrain) )
            Train(i) = true;
        elseif( ismember(parts{1,1}, selectedForTest) )
            Test(i) = true;
        else
            
        end
    end
end