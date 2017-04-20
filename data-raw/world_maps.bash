curl -O http://ec.europa.eu/eurostat/cache/GISCO/geodatafiles/CNTR_2014_03M_SH.zip

unzip -o CNTR_2014_03M_SH.zip

rm -r ../data
mkdir ../data

MDFILE="../index.md"

echo -e "# World maps\n" > $MDFILE

for proj in "wintri" "eck4" "kav7" "wgs84" "robinson"
do
  echo -e "## Projectie: ${proj}\n" >> $MDFILE
  mapshaper -i CNTR_2014_03M_SH/Data/CNTR_RG_03M_2014.shp \
   -filter 'CNTR_ID != "AQ"' \
   -proj $proj densify \
   -simplify 3% \
   -o ../data/world_${proj}.shp

  mkdir -p ../${proj}
  mapshaper -i ../data/world_${proj}.shp \
   -o ../${proj}/countries.geojson id-field=CNTR_ID
   echo "[countries.geojson](${proj}/countries.geojson)" >> $MDFILE

  mapshaper -i ../data/world_${proj}.shp \
   -o ../${proj}/countries.topojson id-field=CNTR_ID
   echo "[countries.geojson](${proj}/countries.geojson)" >> $MDFILE
done

rm -r CNTR_2014_03M_SH