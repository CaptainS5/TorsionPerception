% [Jul 4, 2013] Copy from tex/book/matlab... TODO don't replicate.
function m = Rot(axis,theta)

s = sin(theta);
c = cos(theta);

switch axis
 case 1
 m =[1 0  0 0;
     0 c -s 0;
     0 s  c 0;
     0 0  0 1];

 case 2
 m =[c 0 s 0;
     0 1 0 0;
    -s 0 c 0;
     0 0 0 1];
 case 3
 m =[c -s 0 0;
     s  c 0 0;
     0  0 1 0;
     0  0 0 1];
end
