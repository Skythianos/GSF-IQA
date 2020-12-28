function y = isrgb(x)

y = size(x,3)==3;
if y
   if isa(x, 'logical')
      y = false;
   elseif isa(x, 'double')
      % At first just test a small chunk to get a possible quick negative  
      m = size(x,1);
      n = size(x,2);
      chunk = x(1:min(m,10),1:min(n,10),:);         
      y = (min(chunk(:))>=0 && max(chunk(:))<=1);
      % If the chunk is an RGB image, test the whole image
      if y
         y = (min(x(:))>=0 && max(x(:))<=1);
      end
   end
end