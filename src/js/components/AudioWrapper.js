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
                style={styles.button}
                onPress={() => AudioModule.toggleSample(1)}
              >
                <Text></Text>
              </TouchableHighlight>

              <TouchableHighlight
                style={styles.button}
                onPress={() => AudioModule.toggleSample(2)}
              >
                <Text></Text>
              </TouchableHighlight>

              <TouchableHighlight
                style={styles.button}
                onPress={() => AudioModule.toggleSample(3)}
              >
                <Text></Text>
              </TouchableHighlight>

              <TouchableHighlight
                style={styles.button}
                onPress={() => AudioModule.toggleSample(4)}
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
    width: 15,
    height: 15,
    borderRadius: 50,
    overflow: "hidden",
    backgroundColor: 'tomato',
  },
});
