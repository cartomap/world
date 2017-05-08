
rm -r ../data
mkdir ../data

MDFILE="../index.md"
echo -e "# World maps\n" > $MDFILE

year=2014

curl -O http://ec.europa.eu/eurostat/cache/GISCO/geodatafiles/CNTR_${year}_03M_SH.zip
unzip -o CNTR_${year}_03M_SH.zip

echo -e "## ${year}\n" >> $MDFILE

for proj in "wintri" "eck4" "kav7" "wgs84" "robinson"
do
  echo -e "### Projection: ${proj}\n" >> $MDFILE
  mapshaper -i CNTR_${year}_03M_SH/Data/CNTR_RG_03M_${year}.shp \
   -filter 'CNTR_ID != "AQ"' \
   -proj $proj densify \
   -simplify 1% \
   -o ../data/world_${year}_${proj}.shp

  mkdir -p ../${proj}
  mapshaper -i ../data/world_${year}_${proj}.shp \
   -o ../${proj}/countries_${year}.geojson id-field=CNTR_ID
   echo "[countries_${year}.geojson](${proj}/countries_${year}.geojson)" >> $MDFILE

  mapshaper -i ../data/world_${year}_${proj}.shp \
   -o ../${proj}/countries_${year}.topojson id-field=CNTR_ID
   echo "[countries_${year}.topojson](${proj}/countries_${year}.topojson)" >> $MDFILE
done

rm -r CNTR_${year}_03M_SH