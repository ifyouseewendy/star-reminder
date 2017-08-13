import React, { Component } from "react";
import PropTypes from "prop-types";
import {
  Layout,
  Heading,
  DisplayText,
  CalloutCard,
  Button,
  Card,
  FormLayout,
  TextField,
} from "@shopify/polaris";

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      digestCount: props.digestCount,
      deliveryTime: props.deliveryTime,
    };
  }

  valueChanged() {
    return (
      this.props.digestCount !== this.state.digestCount ||
      this.props.deliveryTime !== this.state.deliveryTime
    );
  }

  renderIndex() {
    return (
      <Layout>
        <Layout.Section>
          <DisplayText size="Large">{"> Github Star Reminder"}</DisplayText>
        </Layout.Section>
        <Layout.Section>
          <CalloutCard
            illustration="https://assets-cdn.github.com/images/modules/logos_page/Octocat.png"
            primaryAction={{
              content: "Login via Github",
              url: "/auth/github",
            }}
          >
            <p>Get a digest email of your Github stars every week.</p>
          </CalloutCard>
        </Layout.Section>
      </Layout>
    );
  }

  renderDashboard() {
    return (
      <Layout>
        <Layout.Section>
          <DisplayText size="Large">{"> Github Star Reminder"}</DisplayText>
        </Layout.Section>
        <Layout.Section>
          <Card sectioned>
            <FormLayout>
              <TextField
                label="Email"
                name="email"
                type="email"
                value={this.props.email}
                disabled
              />
              <TextField
                label="Github Username"
                name="github-username"
                type="text"
                value={this.props.githubUserName}
                disabled
              />
              <TextField
                label="Delivery Time"
                name="delivery-time"
                type="datetime-local"
                value={this.state.deliveryTime}
                onChange={v => this.setState({ deliveryTime: v })}
              />
              <TextField
                label="Delivery Digest Count"
                id="hello"
                type="number"
                value={this.state.digestCount}
                min="0"
                onChange={v => this.setState({ digestCount: Number(v) })}
              />
              <Button primary url="#" disabled={!this.valueChanged()} submit>
                Save
              </Button>
            </FormLayout>
          </Card>
        </Layout.Section>
      </Layout>
    );
  }

  render() {
    if (this.props.email) {
      return this.renderDashboard();
    }
    return this.renderIndex();
  }
}

App.propTypes = {
  email: PropTypes.string.isRequired,
  githubUserName: PropTypes.string.isRequired,
  deliveryTime: PropTypes.string.isRequired,
  digestCount: PropTypes.number.isRequired,
};

export default App;
