import Phaser from 'phaser'
import {
    centerGameObjects
} from '../utils'

export default class extends Phaser.State {
    init() {}

    preload() {


        this.scale.fullScreenScaleMode = Phaser.ScaleManager.SHOW_ALL;
        this.scale.scaleMode = Phaser.ScaleManager.SHOW_ALL;

        this.scale.pageAlignHorizontally = true;
        this.scale.pageAlignVertically = true;

        this.loaderBg = this.add.sprite(this.game.world.centerX, this.game.world.centerY, 'loaderBg')
        this.loaderBar = this.add.sprite(this.game.world.centerX, this.game.world.centerY, 'loaderBar')
        centerGameObjects([this.loaderBg, this.loaderBar])

        this.load.setPreloadSprite(this.loaderBar)
        this.load.audio('ambient', 'assets/ambient.mp3')
        this.load.audio('picup', 'assets/picup.mp3')

        this.load.image('bg_ui', 'assets/images/bg_pergamino.jpg')
        this.load.image('bg_choice', 'assets/images/bg_choice.png')
        this.load.image('dummy', 'assets/images/dummy_thumb.png')
        this.load.image('llavecita', 'assets/images/llavecita.png')
        this.load.image('llavecita_thumb', 'assets/images/llavecita_thumb.png')
        this.load.image('cuchillo', 'assets/images/cuchillo.png')
        this.load.image('cuchillo_thumb', 'assets/images/cuchillo_thumb.png')
        this.load.image('palanca', 'assets/images/palanca.png')
        this.load.image('palanca_thumb', 'assets/images/palanca_thumb.png')
        this.load.image('ristra de ajos', 'assets/images/ristra de ajos.png')
        this.load.image('ristra de ajos_thumb', 'assets/images/ristra de ajos_thumb.png')
        this.load.image('martillo', 'assets/images/martillo.png')
        this.load.image('martillo_thumb', 'assets/images/martillo_thumb.png')
        this.load.image('crucifijo', 'assets/images/crucifijo.png')
        this.load.image('crucifijo_thumb', 'assets/images/crucifijo_thumb.png')
        this.load.image('trozo de madera', 'assets/images/trozo de madera.png')
        this.load.image('trozo de madera_thumb', 'assets/images/trozo de madera_thumb.png')
        this.load.image('estaca_thumb', 'assets/images/estaca_thumb.png')
        this.load.image('cocina_bg', 'assets/images/cocina_bg.png')
        this.load.image('pasillo_bg', 'assets/images/pasillo_bg.png')
        this.load.image('fregadero_bg', 'assets/images/fregadero_bg.png')
        this.load.image('dormitorio', 'assets/images/dormitorio.png')
        this.load.image('vampiro_bg', 'assets/images/vampiro_habitacion.png')
        this.load.image('vestibulo', 'assets/images/vestibulo_bg.png')
        this.load.image('sotano', 'assets/images/sotano.png')
        this.load.image('biblioteca', 'assets/images/biblioteca.png')
        this.load.image('escaleras_superiores', 'assets/images/escaleras.png')
        this.load.image('escaleras', 'assets/images/escaleras_2.png')
        this.load.image('sala_de_estar', 'assets/images/azul.png')

        this.load.json('story', 'ink/vampiro.json')
    }

    create() {
        this.state.start('Game')
    }

}