%Assign 2 
%Kwabena Gyasi Bawuah 
%101048814

for sigma = 1e-2:1e-2:0.9
    
    %setting up variable matrices like in part 1 
    W = 50;            
    L = W*3/2; 
    
    G = sparse(W*L);  
    Op = zeros(1, W*L);
    
    Sigmatrix = zeros(L, W);           
    Sig1 = 1;                           
    Sig2 = sigma;                           
   
    %bottleneck remains the same this time.
    box = [W*2/5 W*3/5 L*2/5 L*3/5]; 
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
                Op(n) = 0;
                
            elseif y == 1
                
                if x > box(1) && x < box(2)
                    
                    G(n, n) = -3;
                    G(n, n+1) = Sig2;
                    G(n, n+L) = Sig2;
                    G(n, n-L) = Sig2;
                    
                else
                    
                    G(n, n) = -3;
                    G(n, n+1) = Sig1;
                    G(n, n+L) = Sig1;
                    G(n, n-L) = Sig1;
                    
                end
                
            elseif y == L
                
                if x > box(1) && x < box(2)
                    G(n, n) = -3;
                    G(n, n+1) = Sig2;
                    G(n, n+L) = Sig2;
                    G(n, n-L) = Sig2;
                    
                else
                    
                    G(n, n) = -3;
                    G(n, n+1) = Sig1;
                    G(n, n+L) = Sig1;
                    G(n, n-L) = Sig1;
                    
                end
                
            else
                
                if x > box(1) && x < box(2) && (y < box(3)||y > box(4))
                    
                    G(n, n) = -4;
                    G(n, n+1) = Sig2;
                    G(n, n-1) = Sig2;
                    G(n, n+L) = Sig2;
                    G(n, n-L) = Sig2;
                    
                else
                    
                    G(n, n) = -4;
                    G(n, n+1) = Sig1;
                    G(n, n-1) = Sig1;
                    G(n, n+L) = Sig1;
                    G(n, n-L) = Sig1;
                    
                end
            end
        end
    end
        
    
    for Length = 1 : W
        for Width = 1 : L
            
            if Length >= box(1) && Length <= box(2)
                Sigmatrix(Width, Length) = Sig2;
                
            else
                
                Sigmatrix(Width, Length) = Sig1;
                
            end
            
            if Length >= box(1) && Length <= box(2) && Width >= box(3) && Width <= box(4)
                
                Sigmatrix(Width, Length) = Sig1;
                
            end
        end
    end
            
    
    Voltage = G\Op';
            
    
    sol = zeros(L, W, 1);
    
    for x = 1:W
        
        for y = 1:L
            
            n = y + (x-1)*L;
            
            sol(y,x) = Voltage(n);
            
        end
    end
            
    
    [elecx, elecy] = gradient(sol);
            
    
    J_x = Sigmatrix.*elecx;
    J_y = Sigmatrix.*elecy;
    J = sqrt(J_x.^2 + J_y.^2);
            
   
    figure(1)
    hold on
    if sigma == 0.01
        Curr = sum(J, 2);
        Currtot = sum(Curr);
        Currold = Currtot;
        plot([sigma, sigma], [Currold, Currtot])
    end
    if sigma > 0.01
        Currold = Currtot;
        Curr = sum(J, 2);
        Currtot = sum(Curr);
        plot([sigma-0.01, sigma], [Currold, Currtot])
        xlabel("Sigma")
        ylabel("Current Density")
    end
    title("The Effect of varying the sigma value on Current Density")
    
end