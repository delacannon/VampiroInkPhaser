import { State } from "phaser";
import WebFont from "webfontloader";

export default class extends State {
  init() {
    this.stage.backgroundColor = "#000";
    this.fontsReady = false;
    this.fontsLoaded = this.fontsLoaded.bind(this);
  }

  preload() {
    WebFont.load({
      google: {
        families: ["Roboto Mono"],
      },
      active: this.fontsLoaded,
    });

    let text = this.add.text(
      this.world.centerX,
      this.world.centerY,
      "cargando fuentes...",
      { font: "16px Arial", fill: "#dddddd", align: "center" }
    );
    text.anchor.setTo(0.5, 0.5);

    this.load.image("loaderBg", "./assets/images/loader-bg.png");
    this.load.image("loaderBar", "./assets/images/loader-bar.png");
  }

  render() {
    if (this.fontsReady) {
      this.state.start("Splash");
    }
  }

  fontsLoaded() {
    this.fontsReady = true;
  }
}
