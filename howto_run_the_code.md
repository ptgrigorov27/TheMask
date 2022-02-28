# How to run the code
The code can only be fully tested on Google Cloud. 

However, the Python code that was developed for the Google Cloud Functions to retrieve data from Twitter and Coin API can also be tested locally. Both, the directory `CoinAPICollector` and the directory `TweetCollector` contain a file `main.py` that can be executed with Python3. Both files will make one call to the respective API and will display the result. 

The directory `deployment` contains subdirectories with shell scripts for the deployment on Google Cloud Platform (GCP). Assuming a new GCP setup, the scripts should be executed in the alphanumerical order (i.e. first run the scrip in folder `01_initial_setup`, then the script in folder `02_bigquery`, etc.). Note that the scripts `deploy-cloud-function.sh` do not need to be executed as they are called form within other scripts. 

When testing the scripts and code on a new GCP setup, following adaptations are necessary: 
* The names of most components (especially GCS buckets) need to be changed. 
* The developer has to manually enable the GCP APIs for respective products (for example the BigQuery API, Pub/Sub API, ...)
* A service account has to be created and set up to work with Pub/Sub. This step is documented in `documentation/002_pubsub_setup.md`



