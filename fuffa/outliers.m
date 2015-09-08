% % % %plotfit and delete outliers
 xdata= 1:1:length(Diff(1,:));
% % %
 for n=1:numSpots
% % % % fitResults = polyfit(xdata,Diff(n,:), 7);
% % % % %Evaluate polynomial
% % % % yplot = polyval(fitResults,xdata);
% % % % dist=abs(yplot-Diff(n,:));
% % % % mi=min(Diff(n,:));
% % % % ma=max(Diff(n,:));
% % % % J=find(dist>(ma-mi)/10);
% % % % ind(n,1:length(J))=J;
% %DiffnOutrow=Diff(n,:);
% % %  
% % % %%substitution of outliers. 
% % % %%for mut chip(june exp)
% % % % % a=DiffnOutrow(25:30);
% % % % % b=DiffnOutrow(44:49);
% % % % % c=cat(2,a,b);
% % % % %  DiffnOutrow(31:43)=mean(c);
% % % % %%% 
% % % 
% % % % for j=1:length(J)
% % % %      if J(j)>10 && J(j)<(length(DiffnOutrow)-10)
% % % % DiffnOutrow(J(j))=mean(DiffnOutrow(J(j)-10:J(j)+10));
% % % %      else
% % % %          if J(j)<10 
% % % %          DiffnOutrow(J(j))=mean(DiffnOutrow((J(j)-(J(j)-1)):(J(j)+10)));
% % % %          end
% % % %          if J(j)>length(DiffnOutrow)-10
% % % %           DiffnOutrow(J(j))=mean(DiffnOutrow((J(j)-10:(J(j)+(length(DiffnOutrow)-J(j))))));   
% % % %          end 
% % % %      end
% % % % end
% % % % 
  figure(n)
  h=subplot(3,1,1);
  plot(results.heights(n,:),'o');
  g=subplot(3,1,2);
  plot(annulus.heights(n,:),'o');
  u=subplot(3,1,3);
  plot(Diff(n,:),'o');
  name=num2str(n);
  %saveas(h,name,'fig');
  saveas(h,name,'tiff');
%  
% % % % % % %figure(n+6)
% % % % % % %fitLine1 = plot(xdata,yplot,'DisplayName','7thGrade','Parent')
 end
% % % % % %  
% % % IND=ind;
% % % filename=('IndOut.xlsx');
% % % xlswrite(filename,IND);
