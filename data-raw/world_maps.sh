#curl -O http://ec.europa.eu/eurostat/cache/GISCO/geodatafiles/CNTR_2014_03M_SH.zip
 
#unzip -o CNTR_2014_03M_SH.zip

rm -r ../data
mkdir ../data

# add names and codes to shape file
R -f add_names.R

MDFILE="../index.md"

echo -e "# World maps\n" > $MDFILE

#for proj in "wintri" "eck4" "kav7" "wgs84" "robinson"
for proj in "kav7" "wgs84" "robinson"
do
  echo -e "## Projectie: ${proj}\n" >> $MDFILE
  mapshaper -i world_raw.shp \
   -filter 'id != "AQ"' \
   -proj $proj densify \
   -simplify 1% keep-shapes \
   -o ../data/world_${proj}.shp

  mkdir -p ../${proj}
  mapshaper -i ../data/world_${proj}.shp \
   -o ../${proj}/countries.geojson id-field=id
   echo "[countries.geojson](${proj}/countries.geojson)" >> $MDFILE

  mapshaper -i ../data/world_${proj}.shp \
   -o ../${proj}/countries.topojson id-field=id
   echo "[countries.topojson](${proj}/countries.topojson)" >> $MDFILE
done

#rm -r CNTR_2014_03M_SH