function plot_val_byTrialType(input)
% % plot_val_byTrialType %
%PURPOSE:   Plot lick rates for different trial types
%AUTHORS:   AC Kwan 170518
%
%INPUT ARGUMENTS
%   input:        Structure generated by get_lickrate_byTrialType().

%%
% if called from single-session analysis, input is a struct
% if called from summary analysis, input is a cell array
% here convert everything to a cell array first
if ~iscell(input)
    temp = input;
    clear input;
    input{1} = temp;
end

% load from the cell array
edges=input{1}.edges;
trialType=input{1}.trialType;

val = [];
for j=1:numel(trialType)
    for l=1:numel(input)
        val(j,:,l)=input{l}.val{j};
    end
end

%% calculate sum, mean, and sem

for j=1:numel(trialType)
    val_sum(:,j)=nansum(val(j,:,:),3);    
    val_mean(:,j)=nanmean(val(j,:,:),3);    
    val_sem(:,j)=nanstd(val(j,:,:),[],3)./sqrt(numel(input));
end

%% plot

figure;

minY=nanmin(val_sum(:));
maxY=nanmax(val_sum(:));
%minY=nanmin(val_mean(:))-nanmax(val_sem(:));
%maxY=nanmax(val_mean(:))+nanmax(val_sem(:));
panel_h=numel(trialType);

edges=edges+nanmean(diff(edges))/2; %plot at the center of the bins

trialName = {'All trials','Left trials', 'Right trials'};
for j=1:numel(trialType)
    if j == 2 | j ==3
        minY = min(nanmin(val_sum(:,2:3)));
        maxY = max(nanmax(val_sum(:,2:3)));
    end
    subplot(2,panel_h,j); hold on;
    bar(edges(1:end-1),val_sum(:,j),'FaceColor','k');    
%    bar(edges(1:end-1),val_mean(:,j),'FaceColor','w','EdgeColor','k','LineWidth',3);
%    for k=1:numel(edges)-1
%        plot(edges(k)*[1 1],val_mean(k,j)+val_sem(k,j)*[-1 1],'k','LineWidth',3);
%    end
    plot([0 0],[minY maxY],'k--','LineWidth',2);
    xlim([-0.1 edges(end)]);
    ylim([minY maxY]);
    title(trialName{j},'interpreter','none');
    if j==1
        ylabel('Number of trials');
    end
    xlabel(input{1}.valLabel);
    
end

end

