# ensimmäinen versio suomeksi
class Havaintotaulu < ActiveRecords::Migration
    def up
        create_table :havainnot do |t|
            t.integer :reitti, :null => false
            t.integer :vuosi, :null => false #1986(?) - nykyinen vuosi
            t.integer :reitinpaikka, :null => false #1-999
            t.integer :havainnoijanumero, :null => false #validoidaan Tipu-Apissa
            t.string :kuntakoodi, :limit => 6, :null => false #kuusikirjaiminen
            t.integer :yhtenaiskoordinaatti, :null => false #3+3 (3+['3'+2])
            t.integer :biotooppiluokka, :null => false #1-8
            t.integer :reitinedustavuus, :null => false #0-3
            t.integer :pistelaskentplkm, :null => false # <= tiedossa olevat
            t.integer :kiertolaskentplkm, :null => false # <= tiedossa olevat
            t.string :paikka, :limit => 17, :null => false
            t.integer :ensimlaskentapv, :null => false # integer -> päivä
            t.integer :ensimlaskentakk, :null => false # tyypiksi kk
            t.integer :ensimlaskentah, :null => false # 0-23
            t.integer :ensimlaskentakestomm, :null => false # 1-999
            t.integer :toinenlaskentapv, :null => false # integer -> päivä
            t.integer :toinenlaskentakk, :null => false # tyypiksi kk
            t.integer :toinenlaskentah, :null => false # 0-23
            t.integer :toinenlaskentakestomm, :null => false # 1-999
            t.float :vesistoala # myös null
            t.float :paikanala # myös null
            t.integer :kattaakaiken, :null => false # alustavasti 0, 1 tai 2
            t.integer :paikkarangexx # kattavuusalueen alku
            t.integer :paikkarangeyy # kattavuusalueen loppu
            t.boolean :pistevaikierto, :null => false # true = piste, false = kierto
            t.boolean :kaukoputki, :null => false
            t.boolean :vene, :null => false
            t.integer :anaplaparimaaratulkinta, :null => false #???
            t.integer :anacre, :null => false
            t.integer :anaacu, :null => false
            t.integer :anacly, :null => false
            t.integer :aytfer, :null => false
            t.integer :buccia, :null => false
            t.integer :mermer, :null => false
            t.integer :fulatr, :null => false
            t.integer :gavarc, :null => false
            t.integer :podcri, :null => false
            t.integer :podgri, :null => false
            t.integer :podaur, :null => false
            t.integer :cygcyg, :null => false
            t.integer :ansfab, :null => false
            t.integer :bracan, :null => false
            t.integer :anapen, :null => false
            t.integer :anaque, :null => false
            t.integer :aytful, :null => false
            t.integer :melfus, :null => false
            t.integer :merser, :null => false
            t.integer :meralb, :null => false
            t.boolean :lokkilinnut, :null => false
            t.integer :larmin, :null => false
            t.integer :larrid, :null => false
            t.integer :larcan, :null => false
            t.integer :stehir, :null => false
            t.boolean :kahlaajatjakaulushaikarat, :null => false
            t.integer :galgal, :null => false
            t.integer :trigla, :null => false
            t.integer :trineb, :null => false
            t.integer :trioch, :null => false
            t.integer :acthyp, :null => false
            t.integer :numarq, :null => false
            t.integer :vanvan, :null => false
            t.integer :botste, :null => false
            t.boolean :varpuslinnut, :null => false
            t.integer :embsch, :null => false
            t.integer :acrsch, :null => false         
        end
    end
    
    def down
        drop_table :havainnot
    end
end

class Lisalajit < ActiveRecords::Migration
    def up
        create_table :lisalajit do |t|
            t.integer :havainto_id # viite havaintoon, johon lisälaji kuuluu
            t.string :lajitunnus
            t.integer :lkm
        end
    end
    def down
        drop table :lisalajit
    end
end
            
            
            