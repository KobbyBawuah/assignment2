%Assign 2 
%Kwabena Gyasi Bawuah 
%101048814
%Using q1 b as a background
%setting up variables just like part 1
for meshsize = 10:10:100

    %multiplying these values by the respective meshsize 
    L = (3/2)*meshsize;         
    G = sparse(meshsize*L);   
    Op = zeros(1, meshsize*L); 
    
    
    Sigmatrix = zeros(L, meshsize);       
    Sig1 = 1;                              
    Sig2 = 10^-2;                         
        
   
    %bottleneck conditions with meshsize replacing w
    box = [meshsize*2/5 meshsize*3/5 L*2/5 L*3/5];  
    
   %Filling in G matrix 
    for x = 1:meshsize
        for y = 1:L        
            n = y + (x-1)*L;           
            if x == 1
                G(n, :) = 0;
                G(n, n) = 1;
                Op(n) = 1; 
            elseif x == meshsize
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
    
    %Just like in part a), except using different meshsizes
    for Length = 1 : meshsize
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
    sol = zeros(L, meshsize, 1);
    
    for x = 1:meshsize
        for y = 1:L         
            n = y + (x-1)*L;
            sol(y,x) = Voltage(n);         
        end
    end
    
   %electric field found using gradient of voltage
   [elecx, elecy] = gradient(sol);
   %current desntiy is sigma times electric field
    J_x = Sigmatrix.*elecx;
    J_y = Sigmatrix.*elecy;
    J = sqrt(J_x.^2 + J_y.^2);
    
   %plotting current density vs mesh size                                     
    figure(1)
    hold on
    if meshsize == 10
        Curr = sum(J, 1);                 
        Currtot = sum(Curr);
        Currold = Currtot;
        plot([meshsize, meshsize], [Currold, Currtot])     
    end
    if meshsize > 10
        Currold = Currtot;
        Curr = sum(J, 2);
        Currtot = sum(Curr);
        plot([meshsize-10, meshsize], [Currold, Currtot])
        xlabel("Meshsize")
        ylabel("Current Density")    
    end
    title("Graph of current vs mesh size")

end
