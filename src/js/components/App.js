import React, { Component } from 'react';
import {
  StyleSheet,
  Text,
  View,
  NativeModules
} from 'react-native';
import Maps from './Maps';
import User from './User';
import Record from './Record';
import Library from './Library';
import AudioWrapper from './AudioWrapper';
import HomeScreen from './HomeScreen';

const AudioModule = NativeModules.AudioModule;

class App extends Component {
  constructor(props) {
    super(props);

    this.state = {
      init: null,
      showHome: true,
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

      this.setState({ showHome: false });
    } catch (e) {
      console.error(e);
    }
  }

  render() {
    if (this.state.init == "true") {
      if (this.state.showHome) {
        return <HomeScreen startMap={this.playPause} />
      }
      return (
        <View style={styles.container}>
          <Maps />
          {/* <Record /> */}
          <User />
          <AudioWrapper />
          {/* <Library /> */}
        </View>
      );
    }
    return null;
  }
}

const styles = StyleSheet.create({
  container: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    alignItems: 'center',
  },
});

export default App;
