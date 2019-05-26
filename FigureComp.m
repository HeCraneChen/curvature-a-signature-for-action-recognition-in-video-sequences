%Crane Chen hchen136@jhu.edu
%This function firstly computes the average figure of the same action of different people
%Secondly, cost function is computed and compared between input data and
%the dataset
function [COST,COST_S,result_FigComp]=FigureComp(tau_uni, WAVE11, WAVE12, WAVE21, WAVE22,JUMP11,...
    JUMP12,JUMP21,JUMP22,BEND1,BEND2,WALK1,WALK2,SIDE1,SIDE2,SKIP1,SKIP2,...
    JUMP13,JUMP14,SIDE3,SIDE4,SKIP3,SKIP4,WAVE13,WAVE14,WAVE23,WAVE24)

    WAVE11_plus=mean(WAVE11(1:6,:));
    figure(1);
    plot(tau_uni,WAVE11_plus,'r','LineWidth',4);
    WAVE12_plus=mean(WAVE12(1:6,:));
    figure(11);
    plot(tau_uni,WAVE12_plus,'r','LineWidth',4);
    WAVE13_plus=mean(WAVE13(1:6,:));
    figure(21);
    plot(tau_uni,WAVE13_plus,'r','LineWidth',4);
    WAVE14_plus=mean(WAVE14(1:6,:));
    figure(31);
    plot(tau_uni,WAVE14_plus,'r','LineWidth',4);
    
    WAVE21_plus=mean(WAVE21(1:6,:));
    figure(2);
    plot(tau_uni,WAVE21_plus,'Color',[60 179 113]/256,'LineWidth',4);
    WAVE22_plus=mean(WAVE22(1:6,:));
    figure(12);
    plot(tau_uni,WAVE22_plus,'Color',[60 179 113]/256,'LineWidth',4);
    WAVE23_plus=mean(WAVE23(1:6,:));
    figure(22);
    plot(tau_uni,WAVE23_plus,'Color',[60 179 113]/256,'LineWidth',4);
    WAVE24_plus=mean(WAVE24(1:6,:));
    figure(32);
    plot(tau_uni,WAVE24_plus,'Color',[60 179 113]/256,'LineWidth',4);
    
    JUMP11_plus=mean(JUMP11(1:6,:));
    figure(3);
    plot(tau_uni,JUMP11_plus,'b','LineWidth',4);
    JUMP12_plus=mean(JUMP12(1:6,:));
    figure(13);
    plot(tau_uni,JUMP12_plus,'b','LineWidth',4);
    JUMP13_plus=mean(JUMP13(1:6,:));
    figure(23);
    plot(tau_uni,JUMP13_plus,'b','LineWidth',4);
    JUMP14_plus=mean(JUMP14(1:6,:));
    figure(33);
    plot(tau_uni,JUMP14_plus,'b','LineWidth',4);
    
    JUMP21_plus=mean(JUMP21(1:6,:));
    figure(4);
    plot(tau_uni,JUMP21_plus,'c','LineWidth',4);
    JUMP22_plus=mean(JUMP22(1:6,:));
    figure(14);
    plot(tau_uni,JUMP22_plus,'c','LineWidth',4);
    BEND1_plus=mean(BEND1(1:6,:));
    figure(5);
    plot(tau_uni,BEND1_plus,'m','LineWidth',4);
    BEND2_plus=mean(BEND2(1:6,:));
    figure(15);
    plot(tau_uni,BEND2_plus,'m','LineWidth',4);
    WALK1_plus=mean(WALK1(1:6,:));
    figure(6);
    plot(tau_uni,WALK1_plus,'Color',[184 134 11]/256,'LineWidth',4);
    WALK2_plus=mean(WALK2(1:6,:));
    figure(16);
    plot(tau_uni,WALK2_plus,'Color',[184 134 11]/256,'LineWidth',4);
    
    SIDE1_plus=mean(SIDE1(1:6,:));
    figure(7);
    plot(tau_uni,SIDE1_plus,'k','LineWidth',4);
    SIDE2_plus=mean(SIDE2(1:6,:));
    figure(17);
    plot(tau_uni,SIDE2_plus,'k','LineWidth',4);
    SIDE3_plus=mean(SIDE3(1:6,:));
    figure(27);
    plot(tau_uni,SIDE3_plus,'k','LineWidth',4);
    SIDE4_plus=mean(SIDE4(1:6,:));
    figure(37);
    plot(tau_uni,SIDE4_plus,'k','LineWidth',4);
    
    SKIP1_plus=mean(SKIP1(1:6,:));
    figure(8);
    plot(tau_uni,SKIP1_plus,'Color',[186 85 211]/256,'LineWidth',4);
    SKIP2_plus=mean(SKIP2(1:6,:));
    figure(18);
    plot(tau_uni,SKIP2_plus,'Color',[186 85 211]/256,'LineWidth',4);
    SKIP3_plus=mean(SKIP3(1:6,:));
    figure(28);
    plot(tau_uni,SKIP3_plus,'Color',[186 85 211]/256,'LineWidth',4);
    SKIP4_plus=mean(SKIP4(1:6,:));
    figure(38);
    plot(tau_uni,SKIP4_plus,'Color',[186 85 211]/256,'LineWidth',4);
    
    test1=WAVE11(8,:);%choosing testing data
    test2=WAVE12(8,:);%choosing testing data
    cost1=trapz(abs(test1-WAVE11_plus))+trapz(abs(test2-WAVE12_plus));
    cost2=trapz(abs(test1-WAVE21_plus))+trapz(abs(test2-WAVE22_plus));
    cost3=trapz(abs(test1-JUMP11_plus))+trapz(abs(test2-JUMP12_plus));
    cost4=trapz(abs(test1-JUMP21_plus))+trapz(abs(test2-JUMP22_plus));
    cost5=trapz(abs(test1-BEND1_plus))+trapz(abs(test2-BEND2_plus));
    cost6=trapz(abs(test1-WALK1_plus))+trapz(abs(test2-WALK2_plus));
    cost7=trapz(abs(test1-SIDE1_plus))+trapz(abs(test2-SIDE2_plus));
    cost8=trapz(abs(test1-SKIP1_plus))+trapz(abs(test2-SKIP2_plus));
    COST=[cost1,cost2,cost3,cost4,cost5,cost6,cost7,cost8];
    [minCOST,index]=min(COST);
    
    if(index==3 || index==7 || index==8)
        test3=JUMP13(9,:);%choosing testing data
        test4=JUMP14(9,:);%choosing testing data
        cost3_s=trapz(abs(test1-JUMP11_plus))+trapz(abs(test2-JUMP12_plus))+...
            +trapz(abs(test3-JUMP13_plus))+trapz(abs(test4-JUMP14_plus));
        cost7_s=trapz(abs(test1-SIDE1_plus))+trapz(abs(test2-SIDE2_plus))+...
            +trapz(abs(test3-SIDE3_plus))+trapz(abs(test4-SIDE4_plus));
        cost8_s=trapz(abs(test1-SKIP1_plus))+trapz(abs(test2-SKIP2_plus))+...
            +trapz(abs(test3-SKIP3_plus))+trapz(abs(test4-SKIP4_plus));
        COST_S=[cost3_s, cost7_s, cost8_s];
        [minCOST_S,index_s]=min(COST_S);
        if(index_s == 1)
            index=3;
        end
        if(index_s == 2)
            index=7;
        end
        if(index_s == 3)
            index=8;
        end
    end
    
    if(index==1 || index==2)
        test3=WAVE13(8,:);%choosing testing data
        test4=WAVE14(8,:);%choosing testing data
        cost1_s=trapz(abs(test1-WAVE11_plus))+trapz(abs(test2-WAVE12_plus))+...
            +trapz(abs(test3-WAVE13_plus))+trapz(abs(test4-WAVE14_plus));
        cost2_s=trapz(abs(test2-WAVE21_plus))+trapz(abs(test2-WAVE22_plus))+...
            +trapz(abs(test3-WAVE23_plus))+trapz(abs(test4-WAVE24_plus));
        COST_S=[cost1_s, cost2_s];
        [minCOST_S,index_s]=min(COST_S);
        if(index_s == 1)
            index=1;
        end
        if(index_s == 2)
            index=2;
        end
    end
    
    
    result_FigComp=index;
end
