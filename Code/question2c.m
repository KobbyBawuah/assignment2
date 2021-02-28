%Assign 2 
%Kwabena Gyasi Bawuah 
%101048814

for bottleneck = 0.1:0.01:0.9

 %setting up variable matrices like in part 1   
    W = 100;            
    L = W*3/2;        
    G = sparse(W*L);  
    Op = zeros(1, W*L);
    
    Sigmatrix = zeros(L, W); 
    Sig1 = 10^-2;              
    Sig2 = 1;            
   
    
    %The bottleneck is incrementally "narrowed" by modifying the y values
    %of the box
    box = [W*2/5 W*3/5 L*bottleneck L*(1-bottleneck)]; 
    
    %filling in the G matrix
    for i = 1:W
        
        for j = 1:L
            
            n = j + (i-1)*L;
            
            if i == 1
                
                G(n, :) = 0;
                G(n, n) = 1;
                Op(n) = 1;
                
            elseif i == W
                
                G(n, :) = 0;
                G(n, n) = 1;
                Op(n) = 0;
                
            elseif j == 1
                
                if i > box(1) && i < box(2)
                    
                    G(n, n) = -3;
                    G(n, n+1) = Sig1;
                    G(n, n+L) = Sig1;
                    G(n, n-L) = Sig1;
                    
                else
                    
                    G(n, n) = -3;
                    G(n, n+1) = Sig2;
                    G(n, n+L) = Sig2;
                    G(n, n-L) = Sig2;
                    
                end
                
            elseif j == L
                
                if i > box(1) && i < box(2)
                    G(n, n) = -3;
                    G(n, n+1) = Sig1;
                    G(n, n+L) = Sig1;
                    G(n, n-L) = Sig1;
                    
                else
                    
                    G(n, n) = -3;
                    G(n, n+1) = Sig2;
                    G(n, n+L) = Sig2;
                    G(n, n-L) = Sig2;
                    
                end
                
            else
                
                if i > box(1) && i < box(2) && (j < box(3)||j > box(4))
                    
                    G(n, n) = -4;
                    G(n, n+1) = Sig1;
                    G(n, n-1) = Sig1;
                    G(n, n+L) = Sig1;
                    G(n, n-L) = Sig1;
                    
                else
                    
                    G(n, n) = -4;
                    G(n, n+1) = Sig2;
                    G(n, n-1) = Sig2;
                    G(n, n+L) = Sig2;
                    G(n, n-L) = Sig2;
                    
                end
            end
        end
    end
    
    
    for Length = 1 : W
        
        for Width = 1 : L
            
            if Length >= box(1) && Length <= box(2)
                Sigmatrix(Width, Length) = Sig1;
                
            else
                Sigmatrix(Width, Length) = Sig2;
                
            end
            
            if Length >= box(1) && Length <= box(2) && Width >= box(3) && Width <= box(4)
                
                Sigmatrix(Width, Length) = Sig2;
            end
        end
    end
        
    
    Voltage = G\Op';
    
    
    sol = zeros(L, W, 1);
    
    for i = 1:W
        
        for j = 1:L
            
            n = j + (i-1)*L;
            sol(j,i) = Voltage(n);
            
        end
    end
        
    %The electric field can be derived from the surface voltage using a
    %gradient
    [elecx, elecy] = gradient(sol);
        
    %J, the current density, is calculated by multiplying sigma and the
    %electric field together.

    J_x = Sigmatrix.*elecx;
    J_y = Sigmatrix.*elecy;
    J = sqrt(J_x.^2 + J_y.^2);
        
   %plotting bottleneck vs current
    figure(1)
    hold on
    
    if bottleneck == 0.1
        
        Curr = sum(J, 2);
        Currtot = sum(Curr);
        Currold = Currtot;
        plot([bottleneck, bottleneck], [Currold, Currtot])
        
    end
    
    if bottleneck > 0.1
        
        Currold = Currtot;
        Curr = sum(J, 2);
        Currtot = sum(Curr);
        plot([bottleneck-0.01, bottleneck], [Currold, Currtot])
        xlabel("Bottleneck");
        ylabel("Current Density");
        
    end
    
    title("The Effect of narrowing bottleneck on the Current Density")

end