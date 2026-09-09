おはようございます。

昨日の議論を踏まえ、Windows Server、Red Hat Enterprise Linux、Ubuntuの3種類について、MID Serverの月額ランニングコストを比較しました。

なお、「1台のMID Serverで400台のACC」と記載されていますが、今回は4,000台の誤記として計算しています。

【計算条件】

・Azureリージョン：Japan East  
・稼働時間：24時間365日（730時間/月）  
・VMサイズ：Standard_B4ms  
・CPU／メモリ：4 vCPU、16 GiB  
・OSディスク：Standard SSD、32 GiB  
・料金モデル：Pay-as-you-go  
・対象ACC数：300,000台  
・1台のMID ServerあたりのACC数：4,000台  

【1台あたりの月額費用】

・Ubuntu：約161.54 USD/月  
・Windows Server：約173.22 USD/月  
・Red Hat Enterprise Linux：約203.59 USD/月  

費用差は以下のとおりです。

・UbuntuはWindows Serverより約11.68 USD/月安い  
・UbuntuはRHELより約42.05 USD/月安い  
・RHELはWindows Serverより約30.37 USD/月高い  

RHELの費用には、Red Hat Enterprise Linuxのソフトウェア料金が含まれています。一方、Ubuntuでは追加の商用OSライセンス費用は発生していません。

【必要なMID Server台数】

300,000台 ÷ 4,000台 = 75台

75台で計算した場合は、以下のとおりです。

・Ubuntu：約12,115.50 USD/月  
・Windows Server：約12,991.50 USD/月  
・RHEL：約15,269.10 USD/月  

【構成を選定した根拠】

・ServiceNow MID Server system requirements  
ServiceNowにおけるMID Serverの基本的なシステム要件、対応OS、CPU、メモリなどを確認するための資料です。  
https://www.servicenow.com/docs/r/servicenow-platform/mid-server/r_MIDServerSystemRequirements.html

・ServiceNow Agent Client Collector Installation  
ACCの接続上限やMID Serverの処理容量を確認するための資料です。デフォルトでは1台のMID Serverあたり4,000台のACCが設定されており、8 GiBのJVM Heapで最大約8,000台のACCをサポートできると記載されています。  
https://www.servicenow.com/docs/r/it-operations-management/agent-client-collector/acc-installation.html

・Microsoft Azure Standard B4ms specifications  
Azure Standard_B4msのハードウェア仕様と性能特性を確認するための資料です。4 vCPU、16 GiBメモリ、CPUクレジットを利用するバースト型VMであることを確認できます。  
https://learn.microsoft.com/en-us/azure/virtual-machines/sizes/general-purpose/bv1-series

つまり、1つ目の資料でServiceNowが求めるMID Serverの要件を確認し、2つ目の資料でACC数とMID Serverの処理容量を確認し、3つ目の資料でAzure B4msのハードウェア仕様と性能特性を確認しています。

今回のStandard_B4msは、4 vCPU・16 GiBという条件で比較するための候補構成です。ServiceNowがAzure B4msを直接推奨しているわけではありません。また、B4msはバースト型VMのため、本番環境で使用する場合は、PoCでCPU使用率、CPUクレジット、メモリ使用率、JVM Heapおよび処理遅延を確認したうえで、最終的なVMサイズを決定する必要があります。

今回の金額はAzure Pricing Calculatorによる初期見積もりであり、バックアップ、監視、ネットワーク、冗長化、税金などの追加費用は含まれていません。
