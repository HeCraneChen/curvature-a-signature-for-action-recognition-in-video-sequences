%Crane Chen, hchen136@jhu.edu
%This is a code for subtracting the background of all the single actions
%for Weizmann Dataset
clearvars;

n=8;
arr = cell(1,n);
arr(1) = {'wave1'};
arr(2) = {'wave2'};
arr(3) = {'jump1'};
arr(4) = {'jump2'};
arr(5) = {'bend'};
arr(6) = {'walk'};
arr(7) = {'side'};
arr(8) = {'skip'};

for j=1:2 

    vid_path = strcat('/Users/crane/Documents/MATLAB/Single Action/',arr(j),'/');
    vid_path = vid_path{1};
    bg_path = '/Users/crane/Documents/MATLAB/backgrounds/';
    save_path = strcat('/Users/crane/Documents/MATLAB/Single Action_plus/',arr(j),'/');
    save_path = save_path{1};

    cd(vid_path);


    list = dir('*.avi*');

    for i = 1:length(list)
        id = list(i).name;
        A=0;B=0;C=0;D=0;E=0;F=0;G=0;H=0;I=0;
    
        A = strfind(id, 'daria');
        if(A == 1)
            bg_id = 'bg_015.avi';
        end
    
        B = strfind(id, 'denis');
        if(B == 1)
            bg_id = 'bg_026.avi';
        end
    
        C = strfind(id, 'eli');
        if(C == 1)
            bg_id = 'bg_062.avi';
        end
    
        D = strfind(id, 'ido');
        if(D == 1)
            bg_id = 'bg_062.avi';
        end
    
        E = strfind(id, 'ira');
        if(E == 1)
            bg_id = 'bg_007.avi';
        end
    
        F = strfind(id, 'lena');
        if(F == 1)
            bg_id = 'bg_038.avi';
        end
    
        G = strfind(id, 'lyova');
        if(G == 1)
            bg_id = 'bg_046.avi';
        end
    
        H = strfind(id, 'moshe');
        if(H == 1)
            bg_id = 'bg_070.avi';
        end
    
        I = strfind(id, 'shahar');
        if(I == 1)
            bg_id = 'bg_079.avi';
        end
    
        cd(vid_path);
        raw_X  = RGB2Gray_signal(id);
        mask_X = raw_X;
        mask_Xs=reshape(mask_X,144,180,1,size(raw_X, 3));
    
        cd(bg_path)
        bg_X = RGB2Gray_signal(bg_id);
  
    
        for i = 1:size(raw_X, 3)
            mask_X(:, :, i) = uint8(abs(raw_X(:, :, i) - bg_X(:, :, 1)));

            %mask_Xs=reshape(mask_X,144,180,1,size(raw_X, 3));
            mask_Xs(:,:,1,i)=mask_X(:,:,i);
        
            if(A==1)
                %v=VideoWriter('daria_wave_p.avi');
                name = strcat('daria_',arr(j),'_p.avi');
               
            end
            if(B==1)
                %v=VideoWriter('denis_wave_p.avi');
                name = strcat('denis_',arr(j),'_p.avi');
               
            end
            if(C==1)
                %v=VideoWriter('eli_wave_p.avi');
                 name = strcat('eli_',arr(j),'_p.avi');
                
            end
            if(D==1)
                %v=VideoWriter('ido_wave_p.avi');
                 name = strcat('ido_',arr(j),'_p.avi');
                
            end
            if(E==1)
                %v=VideoWriter('ira_wave_p.avi');
                name = strcat('ira_',arr(j),'_p.avi');
            end
            if(F==1)
                %v=VideoWriter('lena_wave_p.avi');
                name = strcat('lena_',arr(j),'_p.avi');
            end
            if(G==1)
                %v=VideoWriter('lyova_wave_p.avi');
                name = strcat('lyova_',arr(j),'_p.avi');
            end
            if(H==1)
                %v=VideoWriter('moshe_wave_p.avi');
                 name = strcat('moshe_',arr(j),'_p.avi');
            end
            if(I==1)
                %v=VideoWriter('shahar_wave_p.avi');
                name = strcat('shahar_',arr(j),'_p.avi');
            end
            
            name = name{1};
            v=VideoWriter(name);
        
            open(v)
            writeVideo(v,uint8(mask_Xs(:, :, :,i)))
            close(v);
            cd(save_path); 
        
        end

    end
end    

    



