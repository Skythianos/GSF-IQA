function [feature] = getDarkChannelFeature(img)

    JDark = darkChannel(img);
    [W,H] = size(JDark);
    
    feature = sum(JDark(:)) / (W*H);

end