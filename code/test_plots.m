close all
dataset = 3;
load("reconstruction_dataset_"+num2str(dataset))
figure(1)
hold on
plot_reconstructions(X_all, 0.001);
plotcams(P_ref_cameras)
