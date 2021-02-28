%Assign 2 
%Kwabena Gyasi Bawuah 
%101048814

%initiailizing the dimensions of our matrices, ensuring L is 3/2 times W
W = 100;
L = (3/2)*W;

G = sparse(W*L,W*L);
Op = sparse(W*L,1);

%filling in the G matrix's
for x = 1:W
    for y = 1:L
        n = y + (x-1)*L;
        
        if x == 1
            G(n, :) = 0;
            G(n, n) = 1;
            Op(n) = 1;
        elseif x == W
            G(n, :) = 0;
            G(n, n) = 1;
            Op(n) = 1;
        elseif y == 1
            G(n, :) = 0;
            G(n, n) = 1;
        elseif y == L
            G(n, :) = 0;
            G(n, n) = 1;
        else
            G(n, n) = -4;
            G(n, n+1) = 1;
            G(n, n-1) = 1;
            G(n, n+L) = 1;
            G(n, n-L) = 1;
        end
    end
end

Voltage = G\Op;
sol = zeros(W,L,1);

%surfed matrix (x,y,voltage)
for x = 1:W
    for y = 1:L
        n = y + (x-1)*L;
        sol(x,y) = Voltage(n);
    end  
end   

%variables to be used in our anayltical solution
a = L;
b = W/2;

x2 = linspace(-W/2,W/2, W);
y2 = linspace(0,L,L);

[i,j] = meshgrid(x2,y2);

sol2 = sparse(L,W);

figure(2)
surf(sol)
pause(0.01)
xlabel('X position');
ylabel('Y position');
zlabel('Voltage(x,y)');
title('Voltage Suface plot using the analytical method 2D)');
%iterating to create a summation of the infinite series (finite in this
%case)

for n = 1:2:600
    if rem(n,2)==1
    sol2 = (sol2 + (cosh(n*pi*i/a).*sin(n*pi*j/a))./(n*cosh(n*pi*b/a)));
    surf(x2,y2,(4/pi)*sol2)
    title("Voltage Suface plot using the analytical method in Two Dimensions")
    axis tight
    view(-130,30);
    pause(0.001)
    end
end
