% Develop since 1/28/2013

%% Load data
o = load('FRGC_v1_Exp2_cache');
img_train       = o.img_train;
index_train     = o.index_train;
img_gallery     = o.img_gallery;
index_gallery   = o.index_gallery;
img_probe       = o.img_probe;
index_probe     = o.index_probe;
id_hash_table   = o.id_hash_table;

o = load('FRGC_v2_Exp2_cache');
img_train_extra       = o.img_train;
index_train_extra     = o.index_train;
img_gallery_extra     = o.img_gallery;
index_galleyr_extra   = o.index_gallery;
img_probe_extra       = o.img_probe;
index_probe_extra     = o.index_probe;
id_hash_table_extra   = o.id_hash_table;

%% Quantize

%% Normalize

%% PCA

%% LDA

%% Train & Test