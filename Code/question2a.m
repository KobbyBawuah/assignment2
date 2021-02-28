%Assign 2 
%Kwabena Gyasi Bawuah 
%101048814

% using question 1 a as background 

%initiailizing the dimensions of our matrices, ensuring L is 3/2 times W

W = 100;
L = (3/2)*W;

G = sparse(W*L,W*L);
Op = zeros(L*W,1);


midX = L/2;
midY = W/2;
boxL = L/4;
boxW = W*(2/3);
sigOut = 1;
sigIn = 10^-2;

leftEdge = midX - boxL/2;
rightEdge = midX + boxL/2;
topEdge = midY + boxW/2;
bottomEdge = midY - boxW/2;



for i=1:L
    for j=1:W
        n=j+(i-1)*W;
        nxms = j+(i-2)*W; 
        nxps = j+(i)*W;
        nyms = (j-1)+(i-1)*W;
        nyps = (j+1)+(i-1)*W;   
          if i == 1
            G(n,n) = 1;
            Op(n) = 1;
            sigmaMap(i,j) = sigOut;
        elseif i == L
            G(n,n) = 1;
            Op(n) = 0;
            sigmaMap(i,j) = sigOut;
        elseif (j == W)
            G(n,n) = -3;
            if(i>leftEdge && i<rightEdge)
                G(n,nxms) = sigIn;
                G(n,nxps) = sigIn;
                G(n,nyms) = sigIn;
                sigmaMap(i,j) = sigIn;
            else
                G(n,nxms) = sigOut;
                G(n,nxps) = sigOut;
                G(n,nyms) = sigOut;
                sigmaMap(i,j) = sigOut;
            end
        elseif (j == 1)
            G(n,n) = -3;
            if(i>leftEdge && i<rightEdge)
                G(n,nxms) = sigIn;
                G(n,nxps) = sigIn;
                G(n,nyps) = sigIn;
                sigmaMap(i,j) = sigIn;
            else
                G(n,nxms) = sigOut;
                G(n,nxps) = sigOut;
                G(n,nyps) = sigOut;
                sigmaMap(i,j) = sigOut;
            end
        else
            G(n,n) = -4;
            if( (j>topEdge || j<bottomEdge) && i>leftEdge && i<rightEdge)
                G(n,nxps) = sigIn;
                G(n,nxms) = sigIn;
                G(n,nyps) = sigIn;
                G(n,nyms) = sigIn;
                sigmaMap(i,j) = sigIn;
            else
                G(n,nxps) = sigOut;
                G(n,nxms) = sigOut;
                G(n,nyps) = sigOut;
                G(n,nyms) = sigOut;
                sigmaMap(i,j) = sigOut;
            end
        end
    end
end

Voltage = G\Op;
sol = zeros(L,W);

for x=1:L
    for y=1:W
        n = y + (x-1) * W;
        sol(x,y)= Voltage(n);
    end
end

%The electric field can be derived from the surface voltage using a
%gradient
[Ey,Ex] = gradient(sol);
%J, the current density, is calculated  a surface plot is derived by surfing this matrix.
E = gradient(sol);
J = sigmaMap.* E;

%V(x,y) Surface Plot
figure(4)
subplot(2,1,1);
surf(sigmaMap)
xlabel('x');
ylabel('y');
zlabel('V(x,y)')
title('Sigma Charge Density Plot');

subplot(2,1,2);
surf(phi)
xlabel('x');
ylabel('y');
zlabel('V(x,y)')
title('Voltage Plot');

%X component of electric field surface plot
figure(5)
subplot(2,1,1);
surf(Ex)
xlabel('x');
ylabel('y');
zlabel('V(x,y)')
title('Electric Field Plot for x');

%Y component of electric field surface plot
subplot(2,1,2);
surf(Ey)
xlabel('x');
ylabel('y');
zlabel('V(x,y)')
title('Electric Field Plot for y');

figure(6)
surf(J)
xlabel('x');
ylabel('y');
zlabel('V(x,y)')
title('Current Density σ(x, y)');