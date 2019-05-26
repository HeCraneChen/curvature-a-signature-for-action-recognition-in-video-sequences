%Crane Chen, hchen136@jhu.edu
%This is GORA algorithm with curvature calculation. 
%Collaborate with Mengdi.
clearvars; close all;

n=8;
arr = cell(1,n);
arr(1) = {'wave1'};%color r
arr(2) = {'wave2'};%color plot(tau,K,'Color',[60 179 113]/256) green
arr(3) = {'jump1'};%color b
arr(4) = {'jump2'};%color c
arr(5) = {'bend'};%color m
arr(6) = {'walk'};%plot(tau,K,'Color',[184 134 11]/256) brown
arr(7) = {'side'};%color k
arr(8) = {'skip'};%plot(tau,K,'Color',[186 85 211]/256) purple
k_pre=0;
k=0;
p=1;
q=1;
for j=1:8 % 8 of different actions
    path = strcat('/Users/crane/Documents/MATLAB/Single Action_plus/',arr(j),'/');
    path = path{1};
    list=dir([path,'*.avi']);
    k_pre=k;
    k=length(list);
    %COST=zeros(1,k);
    for i=1:k %different people
      str =  strcat(path,list(i).name)
      X_s = import_random_Gray(str);
      s0 = (0:size(X_s, 3)-1)/(size(X_s, 3) - 1);
      
      %tau when interp_Gray_nbh is present
      %dtau = .01;
      %tau = 0:dtau:1;
      %X_s1 = interp_Gray_nbh(s0, X_s, tau); 
      
      %tau when interp_Gray_nbh is deleted
      dtau=1/(size(X_s, 3) - 1);
      tau=0:dtau:1;
     
      X1 = vectorize_Gray(X_s);%this needs to be changed when interpolation is added or deleted
      [X1_opt, tau1_opt,c,F] = GORA(X1, tau); 
      
      %Curvature Calculation
      %[K1,K2] = curvature_calc(c,F,X1_opt);
      %[K_matr,K_test,e]=CurvatureCalc_advanced(c,F,tau, X1_opt,9);%testing n-order curvatures
      [K1,K2] = curvature_calc(c,F,X1_opt);
      %K1 = K_matr(1,:);
      %K2 = K_matr(2,:);
%       K3 = K_matr(3,:);
%       K4 = K_matr(4,:);
      K1 = df_array(1, tau, X1_opt, 2, 2);
      K1= sqrt(sum(K1.^2));
      K2 = df_array(2, tau, X1_opt, 2, 2);
      K2= sqrt(sum(K2.^2));
%       K3 = df_array(3, tau, X1_opt, 3, 2);
%       K3= sqrt(sum(K3.^2));
%       K4 = df_array(4, tau, X1_opt, 4, 2);
%       K4= sqrt(sum(K4.^2));
      
      tau_uni = 0:0.01:1;
      K1_s = interp1(tau, K1, tau_uni,'spline');
      K2_s = interp1(tau, K2, tau_uni,'spline');
%       K3_s = interp1(tau, K3, tau_uni,'spline');
%       K4_s = interp1(tau, K4, tau_uni,'spline');
      K1= (K1_s-min(K1_s))/(max(K1_s)-min(K1_s));
      K2= (K2_s-min(K2_s))/(max(K2_s)-min(K2_s));
%       K3= (K3_s-min(K3_s))/(max(K3_s)-min(K3_s));
%       K4= (K4_s-min(K4_s))/(max(K4_s)-min(K4_s));
      
      %Pattern Calculation
      %Pattern of Center Position
      Mean1=mean(K1);
      Mean2=mean(K2);
      Median1=median(K1);
      Median2=median(K2);
      %Pattern of divergence
      Range1=max(K1_s)-min(K1_s);%range should be calculated with data before normalization
      Range2=max(K2_s)-min(K2_s);
      Standard1=std(K1,0);
      Standard2=std(K2,0);
      CV1=Standard1/Mean1;%Coefficient of Variation
      CV2=Standard2/Mean2;
      %Other patterns
      Waverate1=quantile(K1,0.9)-quantile(K1,0.1);
      Waverate2=quantile(K2,0.9)-quantile(K2,0.1);
      Skewness1=skewness(K1);
      Skewness2=skewness(K2);
      Kurtosis1=kurtosis(K1);
      Kurtosis2=kurtosis(K2);
      %Multimodal pattern
      Beta1=((Skewness1)^2+1)/( Kurtosis1);
      Beta2=((Skewness2)^2+1)/( Kurtosis2);
      %Specific pattern for actions 3, 7, and 8 as well as 1 and 2
%       if(j==3 || j==7 || j==8 || j==1 || j==2)
%           Mean3=mean(K3);
%           Median3=median(K3);
%           Range3=max(K3_s)-min(K3_s);
%           Standard3=std(K3,0);
%           CV3=Standard3/Mean3;
%           Waverate3=quantile(K3,0.9)-quantile(K3,0.1);
%           Skewness3=skewness(K3);
%           Kurtosis3=kurtosis(K3);
%           Beta3=((Skewness3)^2+1)/( Kurtosis3);
% 
%           Mean4=mean(K4);
%           Median4=median(K4);
%           Range4=max(K4_s)-min(K4_s);
%           Standard4=std(K4,0);
%           CV4=Standard4/Mean4;
%           Waverate4=quantile(K4,0.9)-quantile(K4,0.1);
%           Skewness4=skewness(K4);
%           Kurtosis4=kurtosis(K4);
%           Beta4=((Skewness4)^2+1)/( Kurtosis4);
%       end
      
      
      
      %generate Dataset
      Data(p,:)=[Mean1,Mean2,Median1,Median2,...
              Range1,Range2,Standard1,Standard2,CV1,CV2,Waverate1,...
              Waverate2,Skewness1,Skewness2,Kurtosis1,Kurtosis2,...
              Beta1,Beta2,j];
       p=p+1;
       
%        if(j==3 || j==7 || j==8)
%             Data_s(q,:)=[Mean1,Mean2,Median1,Median2,...
%               Range1,Range2,Standard1,Standard2,CV1,CV2,Waverate1,...
%               Waverate2,Skewness1,Skewness2,Kurtosis1,Kurtosis2,...
%               Beta1,Beta2,Mean3,Mean4,Median3,Median4,Range3,Range4,Standard3,...
%               Standard4,CV3,CV4,Waverate3,Waverate4,Skewness3,Skewness4...
%                 Kurtosis3,Kurtosis4,Beta3,Beta4,j];
%             q=q+1;
%        end
       
      
      %plot the figures
%     cost=trapz(abs(K-K_pre));
%     COST(i)=cost;
      if(j==1)
          WAVE11(i,:)=K1;
          WAVE12(i,:)=K2;
%           WAVE13(i,:)=K3;
%           WAVE14(i,:)=K4;
          figure(1);
          plot(tau_uni,K1,'r');
          hold on
          figure(11);
          plot(tau_uni,K2,'r');
          hold on
%           figure(21);
%           plot(tau_uni,K3,'r');
%           hold on
%           figure(31);
%           plot(tau_uni,K4,'r');
%           hold on
      end
      if(j==2)
          WAVE21(i,:)=K1;
          WAVE22(i,:)=K2;
%           WAVE23(i,:)=K3;
%           WAVE24(i,:)=K4;
          figure(2);
          plot(tau_uni,K1,'Color',[60 179 113]/256);
          hold on
          figure(12);
          plot(tau_uni,K2,'Color',[60 179 113]/256);
          hold on
%           figure(22);
%           plot(tau_uni,K3,'Color',[60 179 113]/256);
%           hold on
%           figure(32);
%           plot(tau_uni,K4,'Color',[60 179 113]/256);
%           hold on
      end
      if(j==3)
          JUMP11(i,:)=K1;
          JUMP12(i,:)=K2;
%           JUMP13(i,:)=K3;
%           JUMP14(i,:)=K4;
          figure(3);
          plot(tau_uni,K1,'b');
          hold on
          figure(13);
          plot(tau_uni,K2,'b');
          hold on
%           figure(23);
%           plot(tau_uni,K3,'b');
%           hold on
%           figure(33);
%           plot(tau_uni,K4,'b');
%           hold on
      end
      if(j==4)
          JUMP21(i,:)=K1;
          JUMP22(i,:)=K2;
          figure(4);
          plot(tau_uni,K1,'c');
          hold on
          figure(14);
          plot(tau_uni,K2,'c');
          hold on
      end
      if(j==5)
          BEND1(i,:)=K1;
          BEND2(i,:)=K2;
          figure(5);
          plot(tau_uni,K1,'m');
          hold on
          figure(15);
          plot(tau_uni,K2,'m');
          hold on
      end
      if(j==6)
          WALK1(i,:)=K1;
          WALK2(i,:)=K2;
          figure(6);
          plot(tau_uni,K1,'Color',[184 134 11]/256);
          hold on
          figure(16);
          plot(tau_uni,K2,'Color',[184 134 11]/256);
          hold on
      end
      if(j==7)
          SIDE1(i,:)=K1;
          SIDE2(i,:)=K2;
%           SIDE3(i,:)=K3;
%           SIDE4(i,:)=K4;
          figure(7);
          plot(tau_uni,K1,'k');
          hold on
          figure(17);
          plot(tau_uni,K2,'k');
          hold on
%           figure(27);
%           plot(tau_uni,K3,'k');
%           hold on
%           figure(37);
%           plot(tau_uni,K4,'k');
%           hold on
      end
      if(j==8)
          SKIP1(i,:)=K1;
          SKIP2(i,:)=K2;
%           SKIP3(i,:)=K3;
%           SKIP4(i,:)=K4;
          figure(8);
          plot(tau_uni,K1,'Color',[186 85 211]/256);
          hold on
          figure(18);
          plot(tau_uni,K2,'Color',[186 85 211]/256);
          hold on
%           figure(28);
%           plot(tau_uni,K3,'Color',[186 85 211]/256);
%           hold on
%           figure(38);
%           plot(tau_uni,K4,'Color',[186 85 211]/256);
%           hold on
      end
    end
end

%generate trainData and testData
trainData=[Data(1:6,:);Data(10:15,:);Data(19:24,:);Data(28:33,:);...
   Data(36:41,:);Data(45:50,:);Data(54:59,:);Data(63:68,:)];
testData=[Data(7:9,:);Data(16:18,:);Data(25:27,:);...
    Data(34:35,:);Data(42:44,:);Data(51:53,:);Data(60:62,:);Data(69:70,:)];

% trainData_s=[Data_s(1:6,:);Data_s(10:15,:);Data_s(19:24,:)];
% testData_s=[Data_s(7:9,:);Data_s(16:18,:);Data_s(25:26,:)];

%Classification
Result=RandomForest_Crane(trainData, testData, 18, 22)
% if(Result==3 || Result==7 || Result==8)
%     Result_s=RandomForest_Crane(trainData_s, testData_s, 36, 1)
% end

%calculate the average of different actions
% [COST,COST_S,result_FigComp]=FigureComp(tau_uni, WAVE11, WAVE12, WAVE21, WAVE22,JUMP11,...
%     JUMP12,JUMP21,JUMP22,BEND1,BEND2,WALK1,WALK2,SIDE1,SIDE2,SKIP1,SKIP2,...
%     JUMP13,JUMP14,SIDE3,SIDE4,SKIP3,SKIP4,WAVE13,WAVE14,WAVE23,WAVE24);
