figure
load('./results/CCA_RAWimage-to-text.mat')
plot(recall, precision,'xr--')
hold on
load('./results/PLS_RAWimage-to-text.mat')
plot(recall, precision,'xb--')
hold on
load('./results/BLM_RAWimage-to-text.mat')
plot(recall, precision,'xg--')
hold on
load('./results/GMMFA_RAWimage-to-text.mat')
plot(recall, precision,'xm--')
hold on
load('./results/CCA_VGG19image-to-text.mat')
plot(recall, precision,'*r-')
hold on
load('./results/PLS_VGG19image-to-text.mat')
plot(recall, precision,'*b-')
hold on
load('./results/BLM_VGG19image-to-text.mat')
plot(recall, precision,'*g-')
hold on
load('./results/GMMFA_VGG19text-to-image.mat')
plot(recall, precision,'*m-')
% figure
% load('./results/CCA_RAWtext-to-image.mat')
% plot(recall, precision,'xr--')
% hold on
% load('./results/PLS_RAWtext-to-image.mat')
% plot(recall, precision,'xb--')
% hold on
% load('./results/BLM_RAWtext-to-image.mat')
% plot(recall, precision,'xg--')
% hold on
% load('./results/GMMFA_RAWtext-to-image.mat')
% plot(recall, precision,'xm--')
% hold on
% load('./results/CCA_VGG19text-to-image.mat')
% plot(recall, precision,'*r-')
% hold on
% load('./results/PLS_VGG19text-to-image.mat')
% plot(recall, precision,'*b-')
% hold on
% load('./results/BLM_VGG19text-to-image.mat')
% plot(recall, precision,'*g-')
% hold on
% load('./results/GMMFA_VGG19text-to-image.mat')
% plot(recall, precision,'*m-')
legend('CCA','PLS','BLM','GMMFA','VGG19+CCA','VGG19+PLS','VGG19+BLM','VGG19+GMMFA')
hold off
xlabel("recall")
ylabel("precision")