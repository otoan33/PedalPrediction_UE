function [trainedModel, validationRMSE] = trainRegressionModel(trainingData,predictorNames,responseName)
    % [trainedModel, validationRMSE] = trainRegressionModel(trainingData)
    % 学習済み回帰モデルとその RMSE を返します。このコードは回帰学習器アプリで学習させたモデル
    % を再作成します。生成されるコードを使用して、同じモデルでの新規データを使用した学習の自動化
    % や、プログラミングによってモデルを学習させる方法の調査を行います。
    %
    %  入力:
    %      trainingData: アプリにインポートされたものと同じ予測子と応答列を含むテーブル。
    %
    %  出力:
    %      trainedModel: 学習済みの回帰モデルを含む構造体。この構造体には、学習済みのモデル
    %       に関する情報をもつさまざまなフィールドが含まれています。
    %
    %      trainedModel.predictFcn: 新規データに関する予測を行う関数。
    %
    %      validationRMSE: RMSE を含む double。アプリでは [履歴] リストにモデルごとの
    %       RMSE が表示されます。
    %
    % このコードを使用して新規データでモデルを学習させます。モデルを再学習させるには、元のデータ
    % または新規データを入力引数 trainingData として、コマンド ラインから関数を呼び出しま
    % す。
    %
    % たとえば、元のデータセット T で学習させた回帰モデルを再学習させるには、次のように入力しま
    % す:
    %   [trainedModel, validationRMSE] = trainRegressionModel(T)
    %
    % 返された 'trainedModel' を使用して新規データ T2 の予測を行うには、次を使用します
    %   yfit = trainedModel.predictFcn(T2)
    %
    % T2 は、少なくとも学習中に使用したものと同じ予測列を含むテーブルでなければなりません。詳細
    % については、次のように入力してください:
    %   trainedModel.HowToPredict
    
    % MATLAB からの自動生成日: 2020/09/16 13:46:07
    
    
    % 予測子と応答の抽出
    % このコードは、データを処理して、モデルに学習させるのに適した
    % 形状にします。
    inputTable = trainingData;
    % predictorNames = {'Thr', 'Speed', 'Accel'};
    predictors = inputTable(:, predictorNames);
    response = inputTable{:,responseName};
    isCategoricalPredictor = [false, false, false];
    
    % 回帰モデルの学習
    % このコードは、すべてのモデル オプションを指定してモデルに学習させます。
    concatenatedPredictorsAndResponse = predictors;
    concatenatedPredictorsAndResponse.Thr_dif_200 = response;
    linearModel = fitlm(...
        concatenatedPredictorsAndResponse, ...
        'interactions', ...
        'RobustOpts', 'off');
    
    % 関数 predict で結果の構造体を作成
    predictorExtractionFcn = @(t) t(:, predictorNames);
    linearModelPredictFcn = @(x) predict(linearModel, x);
    trainedModel.predictFcn = @(x) linearModelPredictFcn(predictorExtractionFcn(x));
    
    % 結果の構造体にさらにフィールドを追加
    trainedModel.RequiredVariables = predictorNames;
    trainedModel.LinearModel = linearModel;
    trainedModel.About = 'この構造体は、回帰学習器 R2019a からエクスポートされた学習済みのモデルです。';
    trainedModel.HowToPredict = sprintf('新しいテーブル T についての予測を行うには、次を使用します: \n yfit = c.predictFcn(T) \n''c'' をこの構造体の変数の名前 (''trainedModel'' など) に置き換えます。 \n \nテーブル T は次によって返される変数を含んでいなければなりません: \n c.RequiredVariables \n変数形式 (行列/ベクトル、データ型など) は元の学習データと一致しなければなりません。 \n追加の変数は無視されます。 \n \n詳細については、<a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appregression_exportmodeltoworkspace'')">How to predict using an exported model</a> を参照してください。');
    
    % 予測子と応答の抽出
    % このコードは、データを処理して、モデルに学習させるのに適した
    % 形状にします。
    inputTable = trainingData;
    % predictorNames = {'Thr', 'Speed', 'Accel'};
    predictors = inputTable(:, predictorNames);
    response = inputTable{:,responseName};
    isCategoricalPredictor = [false, false, false];
    
    validationPredictFcn = @(x) linearModelPredictFcn(x);
    
    % 再代入予測の計算
    validationPredictions = validationPredictFcn(predictors);
    
    % RMSE 検証の計算
    isNotMissing = ~isnan(validationPredictions) & ~isnan(response);
    validationRMSE = sqrt(nansum(( validationPredictions - response ).^2) / numel(response(isNotMissing) ));
    