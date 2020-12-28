function [GCF] = getGlobalContrastFactor( im )

    % 9 different resolution levels
    GCF = 0.0;
    
    resolutions = [1 2 4 8 16 25 50 100 200];
    
    LC = zeros(size(resolutions));
    
    W = size(im,2);
    H = size(im,1);
    
    rIm = im;
    
    for i=1:length(resolutions)
        
        %attempt at resizing as in the paper
        if i>1
          rIm = imresize(im, 1/(2^(i-1)), 'bilinear');      
        end

        W = size(rIm,2);
        H = size(rIm,1);
        
        rL = zeros(size(rIm));
        % compute linear luminance l
        l = (double(rIm(:,:))/255) * 2.2;

        % compute perceptual luminance L
        rL(:,:) = 100 * sqrt(l);
        
        % compute local contrast for each pixel
        lc = 0.0;
        for x=1:H
            for y=1:W
                
                if (x == 1) && (x == H)
                    if (y == 1) && (y == W)
                       lc = lc + 0;
                    elseif (y == 1)
                       lc = lc + abs(rL(x, y) - rL(x,y+1));
                    elseif (y == W)
                        lc = lc + abs(rL(x, y) - rL(x,y-1));
                    else
                        lc = lc + ( abs(rL(x, y) - rL(x,y-1)) + ...
                                abs(rL(x, y) - rL(x,y+1)) )/2;
                    end
                                
                elseif (x == 1)
                    if (y == 1) && (y == W) 
                        lc = lc + abs(rL(x, y) - rL(x+1,y));
                    elseif (y == 1) 
                        lc = lc + ( abs(rL(x, y) - rL(x,y+1)) + ...
                                abs(rL(x, y) - rL(x+1,y)) )/2;
                    elseif (y == W) 
                        lc = lc + ( abs(rL(x, y) - rL(x,y-1)) + ...
                                abs(rL(x, y) - rL(x+1,y)) )/2;
                    else 
                        lc = lc + ( abs(rL(x, y) - rL(x,y-1)) + ...
                                abs(rL(x, y) - rL(x,y+1)) + ...
                                abs(rL(x, y) - rL(x+1,y)) )/3;
                    end
                    
                elseif (x == H)
                    if (y == 1) && (y == W)
                        lc = lc + abs(rL(x, y) - rL(x-1,y));
                    elseif (y == 1) 
                        lc = lc + ( abs(rL(x, y) - rL(x,y+1)) + ...
                                abs(rL(x, y) - rL(x-1,y)) )/2;
                    elseif (y == W) 
                        lc = lc + ( abs(rL(x, y) - rL(x,y-1)) + ...
                                abs(rL(x, y) - rL(x-1,y)) )/2;
                    else 
                        lc = lc + ( abs(rL(x, y) - rL(x,y-1)) + ...
                                    abs(rL(x, y) - rL(x,y+1)) + ...
                                    abs(rL(x, y) - rL(x-1,y)) )/3;
                    end
                else % x > 1 && x < H
                    if (y == 1) && (y == W)
                        lc = lc + ( abs(rL(x, y) - rL(x+1,y)) + ...
                                abs(rL(x, y) - rL(x-1,y)) )/2;
                    elseif (y == 1) 
                        lc = lc + ( abs(rL(x, y) - rL(x,y+1)) + ...
                                    abs(rL(x, y) - rL(x+1,y)) + ...
                                    abs(rL(x, y) - rL(x-1,y)) )/3;
                    elseif (y == W) 
                        lc = lc + ( abs(rL(x, y) - rL(x,y-1)) + ...
                                    abs(rL(x, y) - rL(x+1,y)) + ...
                                    abs(rL(x, y) - rL(x-1,y)) )/3;
                    else 
                        lc = lc + ( abs(rL(x, y) - rL(x,y-1)) + ...
                                    abs(rL(x, y) - rL(x,y+1)) + ...
                                    abs(rL(x, y) - rL(x-1,y)) + ...
                                    abs(rL(x, y) - rL(x+1,y)) )/4;
                    end

                end
            end
        end
        
        % compute average local contrast c
        c(i) = lc/(W*H);
        w(i) = (-0.406385*(i/9)+0.334573)*(i/9)+ 0.0877526;
        
        % compute global contrast factor
        LC(i) = c(i)*w(i);
        GCF = GCF + LC(i);
        
    end  
end