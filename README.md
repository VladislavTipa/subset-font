# subset-font
Создание оптимизированного сета символов из шрифтов для его оптимизации

## Перед использованием
pip install --user fonttools brotli  \
python -c "import sysconfig; print(sysconfig.get_path('scripts'))"  \
export PATH="/c/Users/[пользователь]/AppData/Roaming/Python/Python313/Scripts:$PATH"

## Запуск скрипта
./script.sh font.ttf out/ index.html
