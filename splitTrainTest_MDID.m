function [Train,Test] = splitTrainTest_MDID(Names)

    numberOfImages = size(Names,2);
   
    Train = false(numberOfImages,1);
    Test  = false(numberOfImages,1);
    
    p = randperm(20);
    
    train = p(1:round(20*0.80)); 
    
    for i=1:numberOfImages
        name = Names{i};
        tmp = str2double(name(4:5));
        if( ismember(tmp,train) )
            Train(i)=true;
        else
            Test(i)=true;
        end
    end

end

