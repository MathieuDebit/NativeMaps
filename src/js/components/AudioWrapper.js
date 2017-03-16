/**
 * @flow
 */

import React, { Component } from 'react';
import {
  StyleSheet,
  Text,
  View,
  Button,
  Slider,
  TouchableHighlight,
  NativeModules
} from 'react-native';

const AudioModule = NativeModules.AudioModule;

export default class AudioWrapper extends Component {
  constructor(props) {
    super(props);

    this.state = {
      init: null,
      buttonTitle: 'Play',
    }

    this.playPause = this.playPause.bind(this);
  }

  componentDidMount() {
    this.init();
  }

  async init() {
    try {
      let init = await AudioModule.init();

      this.setState({ init });
    } catch (e) {
      console.error(e);
    }
  }

  async playPause() {
    try {
      let playPause = await AudioModule.playPause();
      let buttonTitle = 'Play';

      if (this.state.buttonTitle == buttonTitle) {
        buttonTitle = 'Pause';
      }

      this.setState({ buttonTitle });
    } catch (e) {
      console.error(e);
    }
  }

  render() {
    return (
      <View style={styles.container}>
        {
          this.state.init == "true" &&

            <View>
              <Button
                style={styles.button}
                onPress={this.playPause}
                title={this.state.buttonTitle}
              />

              <TouchableHighlight
                style={[styles.button, styles.button1]}
                onPress={() => AudioModule.toggleSample(1)}
              >
                <Text></Text>
              </TouchableHighlight>

              <TouchableHighlight
                style={[styles.button, styles.button2]}
                onPress={() => AudioModule.toggleSample(2)}
              >
                <Text></Text>
              </TouchableHighlight>

              <TouchableHighlight
                style={[styles.button, styles.button3]}
                onPress={() => AudioModule.toggleSample(3)}
              >
                <Text></Text>
              </TouchableHighlight>

              <TouchableHighlight
                style={[styles.button, styles.button4]}
                onPress={() => AudioModule.toggleSample(4)}
              >
                <Text></Text>
              </TouchableHighlight>

              <TouchableHighlight
                style={[styles.button, styles.button5]}
                onPress={() => AudioModule.toggleSample(5)}
              >
                <Text></Text>
              </TouchableHighlight>

              <TouchableHighlight
                style={[styles.button, styles.button6]}
                onPress={() => AudioModule.toggleSample(6)}
              >
                <Text></Text>
              </TouchableHighlight>

              <TouchableHighlight
                style={[styles.button, styles.button7]}
                onPress={() => AudioModule.toggleSample(7)}
              >
                <Text></Text>
              </TouchableHighlight>
            </View>
        }
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  text: {
    textAlign: 'center',
    margin: 10,
    width: 270,
  },
  button: {
    position: 'absolute',
    width: 15,
    height: 15,
    borderRadius: 50,
    overflow: 'hidden',
    backgroundColor: '#0099FF',
  },
  button1: { top: -50, left: -40 },
  button2: { top:  90, left: -50 },
  button3: { top: -70, left: 50 },
  button4: { top: 100, left: 70 },
  button5: { top: -100, left: 10 },
  button6: { top: 60, left: 30 },
  button7: { top: 0, left: 120 },
});
