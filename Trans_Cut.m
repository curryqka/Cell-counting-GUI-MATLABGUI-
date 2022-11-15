function J = Trans_Cut(Init)
rect=[420 127 500 220];
J=imcrop(Init,rect);
set(0,'defaultFigurePosition',[100,100,1000,500]);
set(0,'defaultFigureColor',[1 1 1]);
end

