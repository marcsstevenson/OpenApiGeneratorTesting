# Open Api Generator Testing

This is a small project for testing the Open Api Generator version 6.6.0 using the aspnetcore generator. It illustrates a blocking change with the aspnetcore generator that was introduced in version 6.x. The hope, dear reader, is that you can provide some guidance on how to resolve this issue.

## Dependencies

- Java runtime
- Node
- openapi-generator-cli installed (version 6.6.0 used in this example)

  npm install -g @openapitools/openapi-generator-cli

  or

  yarn global add @openapitools/openapi-generator-cli

## Usage

- Run this command and note the files created within the output dir

  openapi-generator-cli generate -g aspnetcore -i event-api-v1.swagger.3.0.3.yaml -o output --additional-properties=buildTarget=library,packageName=OpenApiGeneratorTesting,operationResultTask=true,useCollection=true,useSwashbuckle=true,nullableReferenceTypes=true

- or use generate-test.cmd if using Windows

## The Problem

Nested object types are being created as their own classes for reasons unknown. 5.x versions of the openapi-generator used the same class for nested objects.

Concretely, in this example (event-api-v1.swagger.3.0.3), the BookingCreate and SpeakerCreate models would both generate and have the EventIdentifier type for the EventId property:

```csharp
public class BookingCreate : IEquatable<BookingCreate>
    {
        public EventIdentifier EventId { get; set; }
    }
```

and

```csharp
public class SpeakerCreate : IEquatable<SpeakerCreate>
    {
        public EventIdentifier EventId { get; set; }
    }
```

but with versions 6.x, the BookingCreate and SpeakerCreate models have their own bespoke class type for EventId.

```csharp
public class BookingCreate : IEquatable<BookingCreate>
    {
        public BookingCreateEventId EventId { get; set; }
    }
```

and

```csharp
public class SpeakerCreate : IEquatable<SpeakerCreate>
    {
        public SpeakerCreateEventId EventId { get; set; }
    }
```

This is a huge blocker for adopting 6.x versions of the openapi-generator for an established large project.

## Question

Can this change in behavior be reverted to the 5.x behavior with configuration or with a custom template?

Regarding a custom template, on inspecting the model.mustache file, the provided value for **dataType** is being supplied as  BookingCreateEventId/SpeakerCreateEventId for the EventId property and so this cannot be readily customised.

## Observations

Changing the openapi spec to 3.3 (example, event-api-v1.swagger.3.1.yaml) results in the type of the EventId being set back to EventIdentifier but the generator does not yet support 3.1 and so all of the primitive types are generated as object.

## Resources

- [Open Api Generator](https://openapi-generator.tech/)
- [Differences between OpenAPI Spec 3.0.3 and 3.1.0](https://www.openapis.org/blog/2021/02/16/migrating-from-openapi-3-0-to-3-1-0)
