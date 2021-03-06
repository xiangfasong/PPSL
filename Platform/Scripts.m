Joint=1; 
GaborTrainIdx=[1:40]; 
lambda=50; 
tol2rho=[1e-5, 1.9]; 
PType='realimag'; 
GaborFilterIdx=[1:40]; 
FilterAbs='abs_px'; 
Dataset='Yale'; 
FilterType='Gabor40_real'; 
ReconstructionMethod='ALM_XPDR'; 
FeatureExtractionMethod='Nothing';  
Classifier='kNN'; 
Splits=[1:5]; 
Output='Screen';

Accuracy = cell(length(Splits),1);
D = cell(length(Splits),1);
for sp = 1: length(Splits)
    SingleSplit = Splits(sp);
    [Accuracy{sp},D{sp}] = mainconf(Joint, GaborTrainIdx, lambda, tol2rho, PType, GaborFilterIdx, FilterAbs, Dataset, FilterType, ReconstructionMethod,  FeatureExtractionMethod,  Classifier, SingleSplit, Output);
end
Accuracy = cell2mat(Accuracy);
D = D{1};
length_D = length(D);

ave_Acc = mean( Accuracy , 1 ) ;
[max_Acc,dd] = max( ave_Acc ) ;
max_Dim = D( dd );
std_Acc = std( Accuracy(:,dd) ) ;

if Output=='Screen'
fid = 1;
end

fprintf( fid , 'Dim =\t\t' ) ;
for dd = 1 : length_D
    fprintf( fid , '\t%5d' , D(dd) ) ;
end
fprintf( fid , '\n' ) ;
for ss = 1 : length(Splits),
    s = Splits(ss);
    fprintf( fid, 's = %2d\t%8s' , s , FeatureExtractionMethod ) ;
    for dd = 1 : length_D
        d = D(dd) ;
        fprintf( fid , '\t%.2f ' , Accuracy(ss,dd)*100 ) ;
    end
    fprintf( fid , '\n' ) ;
end
fprintf( fid , 'ave_Acc %8s ' , FeatureExtractionMethod ) ;
for dd = 1 : length_D
    d = D(dd) ;
    fprintf( fid , '\t%.2f ' , ave_Acc(dd)*100 ) ;
end
fprintf( fid , '\n' ) ;
fprintf( fid , '%dTrain max_Acc+-std_Acc = %.2f+-%.2f , max_Dim = %d\n' , i , max_Acc*100 , std_Acc*100 , max_Dim  ) ;
fprintf( fid , '%dTrain data is done!\n',i) ;
